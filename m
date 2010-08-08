Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab0HHNd0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 09:33:26 -0400
Received: from web37604.mail.mud.yahoo.com ([209.191.87.87]:36517 "HELO
	web37604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753700Ab0HHNdZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 09:33:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=bHvpnO9WfCCDnc71Rc6TKVr1Zs6vtTKGBmaI86Kc4fPmAMQfoicxzVmZkAtk2weVq2fPUpL8cTorCyQwYrC/oRa3Rt521n0isyYp3jnQOQ3V5y5acG10+SW2Ox/lqyJmh8Iw84oPXq3npuUWNHg/oZW3B2uwPxmAUqsW/lwKZHc=;
Message-ID: <311964.4070.qm@web37604.mail.mud.yahoo.com>
X-YMail-OSG: am74EYkVM1kRqaSSHrn1nUUykkNZp_wSCX4hxtRNnvxYTV.
 wnynpv2VKS2HHnQD6I.UwY5tpx4_JVCv2EU7lt7Eu6roKBfmtj5UCGbB1_W7
 KQ9CxGoSGZo6AFBjkzMCaqJUT2f_7RNmsbUYfcQW8DDkPbgYgIZ4uLuLFhQ9
 bcY4DDsQyR.oQbmrrisWfVbFSdh6ZakfYiZ3eq6dZnOfbmwtLEkZf65yNhlF
 kqEiMj_xZV7mFDOharycTL.zMsiYodcQ0aA1jRflDpt7OeT1KHDfuR1wbqyc
 gyfxQItHd_J8b.ABuiMnFwjvDggkS9UNa_.rKKlq8dYuHL9MHVW4O4QG3xTT
 GT4GmjMDfHRDE
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Sun, 8 Aug 2010 06:33:23 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 2/2] MEMSTICK: Add driver for Ricoh R5C592 Card reader.
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1281196995.3300.6.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Sat, 7/8/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > > > > 
> > > > > Btw, I want to add a callback from
> driver to card
> > > driver to
> > > > > be able to
> > > > > reset card in case of error (windows
> driver does
> > > that in
> > > > > case of any
> > > > > error)
> > > > > 
> > > > > I would use most of the
> mspro_block_resume for
> > > the
> > > > > implementation for
> > > > > mspro.
> > > > > 
> > > > > Any objections, suggestions?
> > > > > 
> > > > 
> > > > Just toggle a power on it. Power off/power
> on will do
> > > the full reset of
> > > > the controller and the media. You don't have
> to
> > > reinitialize it, as you
> > > > are sure that it's the same stick.
> > > 
> > > Yea, but after such reboot, the device will be in
> serial
> > > mode. So, I
> > > will need to send switch TPC to device. My driver
> doesn't
> > > know how to do
> > > that...., so it would be nice to have callback to
> the
> > > core.
> > > 
> > 
> > Lets ask a different question: why do you think this
> > particular functionality is needed at all? Have you
> encountered any
> > problems which require it (I haven't, btw)?
> 
> I would image using this to verify that stick is still in
> place on I/O
> error.
> 
> If I just power  down/up it, it will loose state, for
> example IO mode,
> reg range, etc...
> 
> But anyway, this isn't very important.
> 

My point was, that problems are better solved as they come.
Windows drivers do a lot of things (like SCSI device emulation), but it
doesn't mean all of them are necessary. Adding code "just because" often
means more work later on.



      
