Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab0J3VbH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 17:31:07 -0400
Received: from nm25-vm0.bullet.mail.ac4.yahoo.com ([98.139.52.240]:29951 "HELO
	nm25-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751571Ab0J3VbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 17:31:05 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 63993.44304.bm@omp1015.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type;
  b=c4Yii4Ffyje1e1zr1f4XoQgAx5Zei8+RErPu/QBJJlxDWdArdMe3xY0D1EvJMjcbwg5TwJETZ3hlwmPp+umhywAjM4fWY9UBkidHZbWhfL8+SX7t+6iCUhII6VewkIGte1JKkKQa1aoGAx0tE0Kp4T9cI/2CDhZxJigT9lCxFU4=;
Message-ID: <188405.11267.qm@web50208.mail.re2.yahoo.com>
X-YMail-OSG: iOLDEDEVM1mj9xTQ234RUaSuAiodXl327DeIAkSEq71zXsB
 iqPAhLYccDxEP1nx_apzLdfWp4Ly4Ezy8NEUuzju4pWUmoyhSCtP7I4jM_iC
 FVPo3DG7ddp6mTxHi9tJEx4ay6Ghz6ZhzXesy1ia6PX8iFLGwatNzKUIv9z6
 9woOgSVglnFmKz74wHq5jtzAx1NjjZnTKspgesA5EqTTUSsCqfPHapYAAreT
 w5yX5jMe525KfbyywOZsqI_mTTJ64qUyp7X43_gyOdkB4hxuTtjGQ546Zlss
 sjcSvGl6Cifp97Ax4X_SL2Ogdu9ulEX4e8qUWJUWPtWowZrb1XotcoXaCXc8
 DS3_XiF_6MBPx6m.6EsucDElHu2t2n._5mA--
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Sat, 30 Oct 2010 14:24:22 -0700 (PDT)
From: Alex Davis <alex14641@yahoo.com>
Subject: Re: CD-ROM size not updated when switching CD-ROM images.
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forwarding to linux-kernel.

I code, therefore I am


--- On Sat, 10/30/10, Alex Davis <alex14641@yahoo.com> wrote:

> From: Alex Davis <alex14641@yahoo.com>
> Subject: Re: CD-ROM size not updated when switching CD-ROM images.
> To: "David Ahern" <dsahern@gmail.com>
> Cc: "Stefan Hajnoczi" <stefanha@gmail.com>, kvm@vger.kernel.org
> Date: Saturday, October 30, 2010, 4:32 PM
> 
> 
> --- On Wed, 10/20/10, David Ahern <dsahern@gmail.com>
> wrote:
> 
> > From: David Ahern <dsahern@gmail.com>
> > Subject: Re: CD-ROM size not updated when switching
> CD-ROM images.
> > To: "Alex Davis" <alex14641@yahoo.com>
> > Cc: "Stefan Hajnoczi" <stefanha@gmail.com>,
> kvm@vger.kernel.org
> > Date: Wednesday, October 20, 2010, 12:44 PM
> > 
> > 
> > On 10/19/10 18:03, Alex Davis wrote:
> > 
> > >> You ejected the CD-ROM on the QEMU side, the
> guest
> > doesn't
> > >> necessarily
> > >> know about the medium change.  What
> happens
> > when you
> > >> use "eject
> > >> /dev/sr0" inside the guest instead?
> > > I get a 'no medium found' error from the 'dd..'
> > command. After
> > > going into the the monitor, ejecting and
> reloading the
> > disk, 
> > > I still get the size of the first disk in the
> guest.
> > 
> > As I recall the old data is coming from the host page
> > cache; it is not
> > seeing the media change. Try dropping the cache in the
> host
> > on a media
> > change (echo 3 > /proc/sys/vm/drop_caches) or
> modify
> > qemu to close and
> > reopen the cdrom device.
> > 
> > David

> I am able to reproduce this problem with just a plain
> kernel using the ata_piix driver, an initrd that just starts a 
> shell, and plain qemu. When the disk is changed via the monitor,
> the guest invokes the error-handling code on the next read of the
> CD-ROM, but the code path doesn't trigger the 'update size' logic.
> I did an experiment where I placed the line 'sdev->changed = 1'
> in the sr_open method in sr.c of the guest > kernel source, the 
> size was updated, but I will look to see if there's something in
> qemu that can be changed to make it work properly.
> 
> Of course any input from the qemu/kvm developers is
> appreciated.
> 
> I code, therefore I am
> 
> > 
> > >>
> > >> I don't know how CD-ROM media change works
> on
> > real
> > >> hardware, but that
> > >> is the behavior that QEMU should be
> following.
> > >>
> > >> Stefan
> > > 
> > > 
> > >       
> > > --
> > > To unsubscribe from this list: send the line
> > "unsubscribe kvm" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> > 
> 
> 
>       
> 


      
