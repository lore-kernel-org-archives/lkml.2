Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab0L1EEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 23:04:54 -0500
Received: from nm16-vm0.bullet.mail.ac4.yahoo.com ([98.139.52.238]:34245 "HELO
	nm16-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753054Ab0L1EEw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 23:04:52 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 864488.77871.bm@omp1030.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=eo6mV8A3Xadd3Mz9/NYCGeDpZ+Mua3FNRFjKwD8kq2umy+0KCfuxfkQeoZ9YQ+yNreXlbajlx4hKR8ITHCXFNxfR7YbCB6DvOfKsdkLnMnSogI6XuOv/hgQL8Yd4HNhl4LL9dI9Tz7vxgmxQ12AO0tuuB1wmDSHwb49BrjPipNw=;
Message-ID: <711019.98747.qm@web65713.mail.ac4.yahoo.com>
X-YMail-OSG: 8hmEKsEVM1n8KTstiFQiCSXQYYk751q8asxFAIF6ZWqjEy0
 00GiimjUYwqOUHNetkbnVzbTtIfAQQ.TILrmPVTMV9OEHyM0plokR0ZCM.Rp
 pOVq.p66aSsnpCk0_.1ArdC8LxAZm_L_t6tWzBPyPf3b4XIMWnY83DFGaiPE
 Ud_LUeS37rzUkOsRlDP0n6acSol_SsEuqOrBrRZJB_U8T_hyKGnrVFd9NmAA
 fnQF3lK2sMXh7kklmoGVVF6HlVsGGKdyC8aVdEtHIddppQ3Rlohyq9fmhHNW
 VQtWdmoN0logqQ92ZVr46GZCx9jI3z6qfq0qh24vHbvMjPNyoH6bonGV4nPN
 d5F5h1Ux57vTWhd_606xzh97JZSu1mHj2j3vYWNAwW1GQYw78iVD3
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.285259
Date: Mon, 27 Dec 2010 20:04:51 -0800 (PST)
From: Tsozik <tsozik@yahoo.com>
Subject: Re: [PATCH 1/1] mct_u232: added _ioctl, _msr_to_icount and _get_icount functions
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, zaitcev@redhat.com
In-Reply-To: <20101227151237.744bbb6e@lembas.zaitcev.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pete,

Many thanks for your reply again. I actually still own an antique HP a230n (disclaimer: I got it from/with my wife and would never buy it myself). According to dmesg it's got built-in 8250-compliant serial:

[vtsozik@f15 serial]$  dmesg | grep -i serial | grep 8250
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[vtsozik@f15 serial]$

So I ran geiger counter against /dev/ttyS0 device for 20 minutes and acquired 20 measurements. Then I compared last average with last 20 minute measurement average acquired via mct_u232 on the laptop placed nearby. The error was ~4% (rounded up). Taking in consideration that measurements were not acquired synchronously (i.e. in 2 different time slots) this is a pretty good match. 

Thank you again,
 Vadim.

--- On Mon, 12/27/10, Pete Zaitcev <zaitcev@redhat.com> wrote:

> From: Pete Zaitcev <zaitcev@redhat.com>
> Subject: Re: [PATCH 1/1] mct_u232: added _ioctl, _msr_to_icount and _get_icount functions
> To: "Tsozik" <tsozik@yahoo.com>
> Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, zaitcev@redhat.com
> Date: Monday, December 27, 2010, 5:12 PM
> On Mon, 27 Dec 2010 12:55:38 -0800
> (PST)
> Tsozik <tsozik@yahoo.com>
> wrote:
> 
> > +static void mct_u232_msr_to_icount(struct
> async_icount *icount,
> > +       
>            
>     unsigned char msr)
> > +{
> > +    /* Translate Control Line states
> */
> > +    if (msr & MCT_U232_MSR_DDSR)
> > +       
> icount->dsr++;
> > +    if (msr & MCT_U232_MSR_DCTS)
> > +       
> icount->cts++;
> > +    if (msr & MCT_U232_MSR_DRI)
> > +       
> icount->rng++;
> > +    if (msr & MCT_U232_MSR_DCD)
> > +       
> icount->dcd++;
> > +} /* mct_u232_msr_to_icount */
> 
> This looks good to me, but since it's a new hardware
> facility that
> we did not use previously, I'd like to make sure this works
> for you.
> 
> > mct_u232_msr_to_icount uses delta nibble to track
> state changes.
> > RM-60 testing showed the same levels as measured by
> PDM-2 in close
> > proximity to RM-60.
> 
> Right, this is good. I have just one request for you: could
> you find
> somewhere a computer with a built-in 8250-compatible serial
> port,
> attach RM-60 to it, and run your counting application
> there?
> I think your patch looks just fine, but I would like to
> make sure
> that we (e.g. mct_u232+patch) are truly compatible now.
> 
> -- Pete
> 


      
