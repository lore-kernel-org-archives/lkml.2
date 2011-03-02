Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab1CBTLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 14:11:51 -0500
Received: from web31802.mail.mud.yahoo.com ([68.142.207.65]:36729 "HELO
	web31802.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756288Ab1CBTLt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 14:11:49 -0500
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Mar 2011 14:11:48 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=Sz8Ifl4B9YJ5Phw3BZ8iSoALQ/Kfkhtm5CwuCL9BGZzd5UT/6RWu1GQkHNcSNK172HPY/pUGaZg5ioIGzHYwpSEe18eru/ubSTeYMM6K0GDPiJPUaRLivrfj64YxezEYKhwpDynI3BFo5Nfg4+4TtnzZL4dWM2pO9H5fPfncXt8=;
Message-ID: <147799.16314.qm@web31802.mail.mud.yahoo.com>
X-YMail-OSG: uwORaicVM1lOpmxCxpkYFa4d45Ceq0LoIy3SuhLK2Ao712Z
 FQvbBOagnNf9E5nKso10faPyGOjNmXHW2p8ELTeUBFJ8LNx1pI6dtjdBWFEh
 OpjeOel4PeFSVf2rqmyi5fXzHBAVT38E2Im9lDzvDj4w8zR0aNVuCZeoc2ZU
 C9UwlHskEA7gucUy8NNvudm4YwQ7V3wm8cMKSsjABW9OP2crfoDnYDUaF_II
 6pKqBjemHJsAPR7a0sDCFg0doKW1MJGmkLHahkzykzAa48QGUHkbXKX_6O_I
 UtfGAv1fzxnICAzhfPUutj_BXGk8_US9au1VI_pCTRjm2CNn6r7FkUy5Hrab
 nllQBQX6Y9agWMVr97YumC_OqSQhi2u97EqVKoDBgCp4_iUHk4L.kQLazwV4
 r
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.109.295617
Date: Wed, 2 Mar 2011 11:05:05 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: UASP: updates and merges
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've merged the latest master (dd9c154). The UASP driver saw the following update:

    [USB] UASP: Unlock device after reset; EP updates
    
    * Unlock the device after reset.
    
    * Initialize urb->ep directly. struct
      uasp_tport_info already records the struct
      usb_host_endpoint which makes it easy to
      directly initialize urb->ep. This anticipates
      when drivers would have to initialize the ep in
      the urb directly as opposed to the USB core
      having to use pipes.
    
    * Use the UAS pipe macros throughout the code for
      endpoint indexes.

The branch can be found here off of master:
https://github.com/ltuikov/linux-2.6

Original posting of the UASP driver can be found here:
http://marc.info/?l=linux-usb&m=129165511732388&w=2

    Luben


--- On Thu, 1/13/11, Luben Tuikov <ltuikov@yahoo.com> wrote:

> From: Luben Tuikov <ltuikov@yahoo.com>
> Subject: UASP: updates and merges
> To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, "Greg KH" <greg@kroah.com>
> Date: Thursday, January 13, 2011, 2:45 AM
> The UASP driver allows you to connect
> to UAS devices and use them
> as SCSI devices.
> 
> I've merged latest master (f87813) and resolved a conflict
> in drivers/scsi/sd.c by adding back the truncation of the
> mode sense data.
> 
> The UASP driver saw the following update:
> 
>     [USB] UASP: factor out GFP flags and make
> them GFP_ATOMIC
>     
>     Factor out the GFP flags and make them
> atomic:
>     1) The SCSI subsystem uses GFP_ATOMIC, e.g.
> before
>     calling the host's slave_alloc callback (at
> the
>     time of this commit).
>     2) As we are a storage driver doing I/O, we
> should
>     use the lowest denominator (highest
> priority)
>     allocation, and of course we shouldn't sleep,
> thus
>     use GFP_ATOMIC.
> 
> The branch can be found here (off of master):
> https://github.com/ltuikov/linux-2.6
> 
> Original posting of the UASP driver can be found here:
> http://marc.info/?l=linux-usb&m=129165511732388&w=2
> 
>    Luben
> 
> 
