Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab0JaBcC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 21:32:02 -0400
Received: from nm12.bullet.mail.ac4.yahoo.com ([98.139.52.209]:21073 "HELO
	nm12.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754335Ab0JaBcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 21:32:00 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 842292.96164.bm@omp1068.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=mAaT/+jfspaKcdtAxrSX1oE9dOtTD/hxgjq5GFBk05wsZW0EP3WTbnZd4Ln1LrsXin4LvifvLOtk30FXVsxT6UteZ/D5u2PN2+p5+MVudPNxf7SrIlqr5dCZ6Fqd5rfPukyvsqTRvO/z18rWV/iYwLqQjkr9IvlhNDtnkJhEaFc=;
Message-ID: <703034.48909.qm@web50208.mail.re2.yahoo.com>
X-YMail-OSG: jdmRRGEVM1nQuj1yvuk6hrK9BRDgA2BBeR_aFDakqwg33nV
 It96xGaEJ5HoCHMcmUYt7Y19Uav6YtNMKd3rEXmSyIk8IFvYmp5.X5qso_mn
 JstFn5b_ukOVqtMqPASZiN0iBti5WuZayURJtb97WwSRtSBQLuQWPsBg4ho6
 cCal2sYuwiVBvIadFrGVr6cs4bDAbmJ1jS3e6mteZroqrsB0x5nny_WSZEbq
 tSo5PJVHgwLZ_HOVSQOzBZyoXtTCdOMWW3.XSMm4ovVSEmOdDonOKZRXNpIa
 qtwVQCdq.6_ia10pqOOSihJTQTDQw9gdbWQhtNp_5JfeM2n8dI5hKmZKq9Z_
 ageDTOS3GcQhLx_8hPyVp.hKg.7hnvSnyqw--
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Sat, 30 Oct 2010 18:31:59 -0700 (PDT)
From: Alex Davis <alex14641@yahoo.com>
Subject: Re: CD-ROM size not updated when switching CD-ROM images.
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry. Here's the thread this is all in reference to:
http://marc.info/?l=kvm&m=128847386629601&w=2

I code, therefore I am


--- On Sat, 10/30/10, Alex Davis <alex14641@yahoo.com> wrote:

> From: Alex Davis <alex14641@yahoo.com>
> Subject: Re: CD-ROM size not updated when switching CD-ROM images.
> To: linux-kernel@vger.kernel.org
> Cc: kvm@vger.kernel.org
> Date: Saturday, October 30, 2010, 5:24 PM
> Forwarding to linux-kernel.
> 
> I code, therefore I am
> 
> 
> --- On Sat, 10/30/10, Alex Davis <alex14641@yahoo.com>
> wrote:
> 
> > From: Alex Davis <alex14641@yahoo.com>
> > Subject: Re: CD-ROM size not updated when switching
> CD-ROM images.
> > To: "David Ahern" <dsahern@gmail.com>
> > Cc: "Stefan Hajnoczi" <stefanha@gmail.com>,
> kvm@vger.kernel.org
> > Date: Saturday, October 30, 2010, 4:32 PM
> > 
> > 
> > --- On Wed, 10/20/10, David Ahern <dsahern@gmail.com>
> > wrote:
> > 
> > > From: David Ahern <dsahern@gmail.com>
> > > Subject: Re: CD-ROM size not updated when
> switching
> > CD-ROM images.
> > > To: "Alex Davis" <alex14641@yahoo.com>
> > > Cc: "Stefan Hajnoczi" <stefanha@gmail.com>,
> > kvm@vger.kernel.org
> > > Date: Wednesday, October 20, 2010, 12:44 PM
> > > 
> > > 
> > > On 10/19/10 18:03, Alex Davis wrote:
> > > 
> > > >> You ejected the CD-ROM on the QEMU side,
> the
> > guest
> > > doesn't
> > > >> necessarily
> > > >> know about the medium change. 
> What
> > happens
> > > when you
> > > >> use "eject
> > > >> /dev/sr0" inside the guest instead?
> > > > I get a 'no medium found' error from the
> 'dd..'
> > > command. After
> > > > going into the the monitor, ejecting and
> > reloading the
> > > disk, 
> > > > I still get the size of the first disk in
> the
> > guest.
> > > 
> > > As I recall the old data is coming from the host
> page
> > > cache; it is not
> > > seeing the media change. Try dropping the cache
> in the
> > host
> > > on a media
> > > change (echo 3 > /proc/sys/vm/drop_caches) or
> > modify
> > > qemu to close and
> > > reopen the cdrom device.
> > > 
> > > David
> 
> > I am able to reproduce this problem with just a plain
> > kernel using the ata_piix driver, an initrd that just
> starts a 
> > shell, and plain qemu. When the disk is changed via
> the monitor,
> > the guest invokes the error-handling code on the next
> read of the
> > CD-ROM, but the code path doesn't trigger the 'update
> size' logic.
> > I did an experiment where I placed the line
> 'sdev->changed = 1'
> > in the sr_open method in sr.c of the guest > kernel
> source, the 
> > size was updated, but I will look to see if there's
> something in
> > qemu that can be changed to make it work properly.
> > 
> > Of course any input from the qemu/kvm developers is
> > appreciated.
> > 
> > I code, therefore I am
> > 
> > > 
> > > >>
> > > >> I don't know how CD-ROM media change
> works
> > on
> > > real
> > > >> hardware, but that
> > > >> is the behavior that QEMU should be
> > following.
> > > >>
> > > >> Stefan
> > > > 
> > > > 
> > > >       
> > > > --
> > > > To unsubscribe from this list: send the
> line
> > > "unsubscribe kvm" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > 
> > > 
> > 
> > 
> >       
> > 
> 
> 
>       
> 


      
