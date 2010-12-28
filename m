Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787Ab0L1PPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 10:15:38 -0500
Received: from nm28.bullet.mail.ac4.yahoo.com ([98.139.52.225]:26889 "HELO
	nm28.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750986Ab0L1PPh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 10:15:37 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 138806.7115.bm@omp1032.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=OVzNMvZ2dVnVuw6ZbpD+VMcfT9qPBQsOeyOAKIWG9gk+KvjkUuFRDr9HEG7wJWdvPFtfWy0z+uzlKLoN8WPCuw/1PQJwSDzIJXhgV0ObnbhnjSGHvnH6LOIVjfDcJfritZPHvsG/XYsjDIUksCaFBRgbyKSbmIR2wFEXR3idCnI=;
Message-ID: <901609.55227.qm@web65702.mail.ac4.yahoo.com>
X-YMail-OSG: L_UakpwVM1l7ao6xMGu9ClNHWIO2jkfC0zXk2._.Dds0MWv
 ev4iwy12Z86iMTl1wSLxC.l9aQqs4FwDq8h2pujCKTm3rmoBiY603uac0TWX
 AYLegeT3mJelZ6eYlP_Gy90k7OASQIMlO86mQqj5TUzlhxq9YzRT4xjHdmfq
 K_S9HR8VwfWOEtJH0qcCkDfecJNYuQr9tbJWCcKReKLGt8ANA5Z0BJ43olYn
 NIkkQ2KXFz3e0zQPnr2U_OMmLI7qoJ0XenettUc5.zgr.hvOWYK7tLMvEMLQ
 AQ.T9fAu6WN7tsXFt.0391B0CNH4kPJ5FD6pawn3kujYR6QuP8piecrKezgG
 mavk8psktyOp20y6LyischdRaOTwY04ISZpybbIAHM8ux5lhqvdE0
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.285259
Date: Tue, 28 Dec 2010 07:15:35 -0800 (PST)
From: Tsozik <tsozik@yahoo.com>
Subject: Re: [PATCH 1/1] mct_u232: added _ioctl, _msr_to_icount and _get_icount functions
To: Greg Kroah-Hartman <gregkh@suse.de>, Pete Zaitcev <zaitcev@redhat.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        zaitcev@redhat.com
In-Reply-To: <20101227234047.3f70a515@lembas.zaitcev.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

I'm sorry to bother you again, but I'm wondering if you could comment on Pete's concern below.

Thank you in advance for your expertise on the matter,
 Vadim. 

--- On Tue, 12/28/10, Pete Zaitcev <zaitcev@redhat.com> wrote:

> From: Pete Zaitcev <zaitcev@redhat.com>
> Subject: Re: [PATCH 1/1] mct_u232: added _ioctl, _msr_to_icount and _get_icount functions
> To: "Tsozik" <tsozik@yahoo.com>
> Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, zaitcev@redhat.com
> Date: Tuesday, December 28, 2010, 1:40 AM
> On Mon, 27 Dec 2010 20:04:51 -0800
> (PST)
> Tsozik <tsozik@yahoo.com>
> wrote:
> 
> > So I ran geiger counter against /dev/ttyS0 device for
> 20 minutes and
> > acquired 20 measurements. Then I compared last average
> with last 20
> > minute measurement average acquired via mct_u232 on
> the laptop placed
> > nearby. The error was ~4% (rounded up).
> 
> Great, I'm ready to ack.
> 
> There's just one thing that is bugging me... I think it
> would be best
> if Alan Cox or Greg Kroah commented on it. The edgeport
> does the
> following, which we copied:
> 
> 
>         schedule();
>         ........
>         if (cnow.rng ==
> cprev.rng && cnow.dsr == cprev.dsr &&
>            
> cnow.dcd == cprev.dcd && cnow.cts == cprev.cts)
>            
> return -EIO; /* no change => error */
>         if (((arg &
> TIOCM_RNG) && (cnow.rng != cprev.rng)) ||
>             ((arg
> & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) ||
>             ((arg
> & TIOCM_CD)  && (cnow.dcd != cprev.dcd))
> ||
>             ((arg
> & TIOCM_CTS) && (cnow.cts != cprev.cts))) {
>            
> return 0;
>         }
> 
> So, if there was a status report, but no change to bits,
> the ioctl
> TIOCMIWAIT would return with -EIO. In serial_core.c, that
> serves
> conventional non-USB UARTs, nothing like this occurs. I am
> not quite
> sure what the point of doing this -EIO check is.
> 
> Oh and BTW, I'm wondering what is going to happen if the
> device is
> disconnected while an application is blocked waiting for
> the status
> change. The patch is not particularly bad here, it just
> copies
> an existing code from elsewhere.
> 
> -- Pete
> 


      
