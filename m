Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab0LZWOr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 17:14:47 -0500
Received: from nm19.bullet.mail.ac4.yahoo.com ([98.139.52.216]:39335 "HELO
	nm19.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752696Ab0LZWOq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 17:14:46 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 61360.10646.bm@omp1029.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=i+FOUV+dJ0oy4SaNa5/h/J7JrPR7V0HLcklULpmzDyrgJQIaLmo9I7o/G0HMFkReyvSvpZVlmbNphyIHPLhNQZ2TnSmSyv55/AiskaHrekNU9qPE7TFgfJBPFFhJtylTmbxgXPFQwA+Cfhm5HlS8jZOhBRhkptHM6EwL3TuEn60=;
Message-ID: <874477.56229.qm@web65712.mail.ac4.yahoo.com>
X-YMail-OSG: ruoJE9UVM1m1opOjH53Dq3vZkMaRn77CRactUhLbC00z_Ru
 L9sgp9QSuKYgbi5Gff_j8nJmXOhaFkN73YfyRzrLbgFtZRQxrDkyR_ciwpDs
 ylyIY4a6KbDK_waD6SbomHdXl7Nvfmcjf7sZDze6VHj6tIr5lfGoJeCN5cvX
 m5KmV0mz4apZ8LyuWIkkO2QAG5rb30WNFmkfjaeYLqGqijmu49JT_YM.vfiR
 xwpvVjWyKlj0pYxeJR1BwkhiR3ernpgXrjkAsM7tef_.ZuIFd2Nd2Dq5WggM
 ByZCa6Pyt_OJNow6iLu6n1R5FqbjmTzVImcwBJrcAtQhLcOvbyGpK.CMZOfV
 WfITkJ_xQI59kO0PDNRTs0v0tHTQHOl0wOeM2UYlRXgiEoWFZ8lwx
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.285259
Date: Sun, 26 Dec 2010 14:14:44 -0800 (PST)
From: Tsozik <tsozik@yahoo.com>
Subject: Re: [PATCH 1/1] mct_u232: IOCTL implementation
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pete,

My apology, reading Greg's post I realized that 2.6.35 (distributed with Fedora 14) is indeed outdated. I just checked out 2.6.37-rc7 tree and saw references to get_icount function. I will definetely address your concern,

Thank you again,
 Vadim.

--- On Sun, 12/26/10, Tsozik <tsozik@yahoo.com> wrote:

> From: Tsozik <tsozik@yahoo.com>
> Subject: Re: [PATCH 1/1] mct_u232: IOCTL implementation
> To: "Pete Zaitcev" <zaitcev@redhat.com>
> Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
> Date: Sunday, December 26, 2010, 2:41 PM
> Pete,
> 
> Many thanks for your comment/concern. I borrowed an
> TIOCGICOUNT implementation from usb/serial/io_ti.c:
> 
>         case TIOCGICOUNT:
>                
> dbg("%s - (%d) TIOCGICOUNT RX=%d, TX=%d", __func__,
>                
>      port->number,
> edge_port->icount.rx, edge_port->icount.tx);
>                 if
> (copy_to_user((void __user *)arg,
> &edge_port->icount,
>                
>                
> sizeof(edge_port->icount)))
>                
>         return -EFAULT;
>                
> return 0;
>         }
> 
> There are 2 similar TIOCGICOUNT implementations listed in
> 
> ark3116.c
> io_edgeport.c
> io_ti.c
> mos7720.c
> mos7840.c
> ti_usb_3410_5052.c
> 
> files under usb/serial/ directory. One based on io_ti.c and
> another based on io_edgeport.c. I borrowed one from io_ti.c,
> since it looked more effecient to me. I searched for any
> mention of get_icount function under linux-2.6.35 and didn't
> find any file which declared or called this function:
> 
> [vtsozik@SR71 linux-2.6.35]$ find . -type f -name '*.[c,h]'
> | xargs grep get_icount
> [vtsozik@SR71 linux-2.6.35]$
> 
> I'm wondering if you could give me a bit more information
> on this. Otherwise I would really prefer to proceed with
> something that already exists and tested. If by some reason
> you believe that alternative implementation from
> io_edgeport.c (please see code snippet below) should be used
> please let me know. Again I didn't see any reason for extra
> copy.
> 
>         case TIOCGICOUNT:
>                
> cnow = edge_port->icount;
>                
> memset(&icount, 0, sizeof(icount));
>                
> icount.cts = cnow.cts;
>                
> icount.dsr = cnow.dsr;
>                
> icount.rng = cnow.rng;
>                
> icount.dcd = cnow.dcd;
>                
> icount.rx = cnow.rx;
>                
> icount.tx = cnow.tx;
>                
> icount.frame = cnow.frame;
>                
> icount.overrun = cnow.overrun;
>                
> icount.parity = cnow.parity;
>                
> icount.brk = cnow.brk;
>                
> icount.buf_overrun = cnow.buf_overrun;
> 
>                
> dbg("%s (%d) TIOCGICOUNT RX=%d, TX=%d",
>                
>                
> __func__,  port->number, icount.rx, icount.tx);
>                 if
> (copy_to_user((void __user *)arg, &icount,
> sizeof(icount)))
>                
>         return -EFAULT;
>                
> return 0;
>         }
> 
> Thank you in advance,
> Vadim.
> 
> --- On Sun, 12/26/10, Pete Zaitcev <zaitcev@redhat.com>
> wrote:
> 
> > From: Pete Zaitcev <zaitcev@redhat.com>
> > Subject: Re: [PATCH 1/1] mct_u232: IOCTL
> implementation
> > To: "Tsozik" <tsozik@yahoo.com>
> > Cc: "Greg Kroah-Hartman" <gregkh@suse.de>,
> linux-usb@vger.kernel.org,
> linux-kernel@vger.kernel.org
> > Date: Sunday, December 26, 2010, 12:49 PM
> > On Sat, 25 Dec 2010 21:39:39 -0800
> > (PST)
> > Tsozik <tsozik@yahoo.com>
> > wrote:
> > 
> > > +++ mct_u232.c  2010-12-25 21:44:57.714640343
> > -0500
> > > +static int  mct_u232_ioctl(struct tty_struct
> > *tty, struct file *file,
> > > +             
> >           unsigned int cmd,
> > unsigned long arg)
> > > +{
> > > +       case TIOCGICOUNT:
> > > +             
> >   dbg("%s - (%d) TIOCGICOUNT RX=%d, TX=%d",
> __func__,
> > > +             
> >       port->number,
> > mct_u232_port->icount.rx,
> mct_u232_port->icount.tx);
> > > +             
> >   if (copy_to_user((void __user *)arg,
> > &mct_u232_port->icount,
> > > +             
> >       sizeof(mct_u232_port->icount)))
> > > +             
> >           return -EFAULT;
> > 
> > This looks suspicious. Didn't we relocate the
> machinery for
> > TIOCGICOUNT
> > into a generic place? Please examine how
> ->get_icount
> > works before
> > hand-rolling the ioctl.
> > 
> > -- Pete
> > 
> 
> 
> 
> 


      
