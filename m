Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594Ab2CTURL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 16:17:11 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:47870 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756308Ab2CTURJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 16:17:09 -0400
Date: Tue, 20 Mar 2012 21:17:00 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: tochansky@tochlab.net
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: uio_pci_generic driver
Message-ID: <20120320201659.GE4987@local>
References: <60a33e825f0ab0e114e6d5a0ea4bda3d.squirrel@www.cloudless.ru>
 <20120320180030.GB808@redhat.com>
 <59b85bdc6223722b86c39a7a028de596.squirrel@www.cloudless.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59b85bdc6223722b86c39a7a028de596.squirrel@www.cloudless.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 10:48:25PM +0400, tochansky@tochlab.net wrote:
> > On Tue, Mar 20, 2012 at 09:56:03PM +0400, tochansky@tochlab.net wrote:
> >> Hello!
> >> I have a question about uio_pci_generic driver. I'm trying to use it in
> >> my
> >> project, but have no luck.
> >> There are very little information on the subject. If you have a few
> >> minutes, I would like to ask a few questions.
> >> I need to mmap() memory of my board to work with it. I did
> >> # modprobe uio_pci_generic
> >> # echo "xxxx xxxx" > /sys/bus/pci/drivers/uio_pci_generic/new_id
> >>
> >> Files in /sys/class/uio/uio0 appears, but there no directory named
> >> /sys/class/uio/uio0/maps/.
> >> Anyway I tryed to mmap with code:
> >>
> >> #include <sys/types.h>
> >> #include <sys/stat.h>
> >> #include <fcntl.h>
> >>
> >> #include <sys/mman.h>
> >> #include <stdio.h>
> >>
> >> int main()
> >> {
> >>         int fd = open("/dev/uio0", O_RDWR | O_SYNC);
> >>         printf("fd = %d\n", fd);
> >>         void *addr = mmap(NULL, 1024, PROT_READ, MAP_SHARED, fd, 0);
> >>         printf("addr = %p\n", addr);
> >> }
> >>
> >> Ofcourse, mmap() failes with error "Invalid argument". Nothing criminal
> >> in
> >> dmesg and any other hints of error.
> >>
> >> --
> >> Dmitriy
> >
> >
> > Map memory through /sys/bus/pci/devices/......
> >
> > Also copy questions to mailing lists please.
> >
> Thanks, it works now.
> 
> #include <sys/types.h>
> #include <sys/stat.h>
> #include <fcntl.h>
> 
> #include <sys/mman.h>
> #include <stdio.h>
> 
> int main() {
>         int fd =
> open("/sys/class/pci_bus/0000:03/device/0000:03:00.0/resource5",
> O_RDWR | O_SYNC);
>         printf("fd = %d\n", fd);
>         void *addr = mmap(NULL, 512, PROT_READ, MAP_SHARED, fd, 0);
>         if(addr == MAP_FAILED)  {
>                 perror("mmap");
>         }
>         else {
>                 printf("addr = %p\n", addr);
>         }
> }
> 
> May be its time to add some hints in documentation? :-)

Good idea. Michael, are you in the mood to hack something up for
Documentation/DocBook/uio-howto.tmpl ?

Thanks,
Hans
