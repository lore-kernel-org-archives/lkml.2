Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007Ab0EBQgl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 12:36:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36492 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757293Ab0EBQgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 12:36:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PhPKvrraegjvQuFmhv1cUW4lDJp8r3cTPpBC4TPwvAv9ZhvkaoMPktFQdeul8iPkYl
         w4DMU6TZjr6BEmHwzsyBWkmRtniyO8HvjsXGICAt/Ay9wA0qGlxh2hCPgslTPjYk2/9A
         quVtashdb8eVk5UqFu6wQajbDwxSUaDCHDs8o=
Date: Sun, 2 May 2010 18:37:11 +0200
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: Komuro <komurojun-mbn@nifty.com>
Cc: linux-pcmcia@lists.infradead.org, linux@dominikbrodowski.net,
       jeff@garzik.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG: invalid hash]  - update pata_pcmcia/ide-cs with
 transcend and kingston cards
Message-ID: <20100502163711.GA1362@boggieman>
Reply-To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
References: <4BD0FD68.90408@garzik.org>
 <20100419195411.f16d8f68.kristoffer.ericson@gmail.com>
 <9179202.147991272799869586.komurojun-mbn@nifty.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9179202.147991272799869586.komurojun-mbn@nifty.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 02, 2010 at 08:31:09PM +0900, Komuro wrote:
> Hi,
> 
> The hash of "CF CARD 1GB" and "TS4GCF133" are wrong.
> 
> pcmcia: pata_pcmcia: invalid hash for product string "CF CARD 1GB": is 0x3e520
> e17, should be 0x55d5bffb
> pcmcia: see Documentation/pcmcia/devicetable.txt for details
> pcmcia: pata_pcmcia: invalid hash for product string "TS4GCF133": is 0x9351e59
> d, should be 0x7558f133
> pcmcia: see Documentation/pcmcia/devicetable.txt for details
> 

Ah, must have used the wrong hash settings on my converter for
those. Will post fixup patch shortly. Thanks!

Kristoffer


> >
> >On 04/19/2010 01:54 PM, Kristoffer Ericson wrote:
> >> This patch adds idstrings for Kingston 1GB/4GB and Transcend 4GB/8GB.
> >>
> >> Signed-off-by: Kristoffer Ericson<kristoffer.ericson@gmail.com>
> >>
> >> diff --git a/drivers/ide/ide-cs.c b/drivers/ide/ide-cs.c
> >> index ab87e4f..defce28 100644
> >> --- a/drivers/ide/ide-cs.c
> >> +++ b/drivers/ide/ide-cs.c
> >> @@ -409,6 +409,8 @@ static struct pcmcia_device_id ide_ids[] = {
> >>   	PCMCIA_DEVICE_PROD_ID12("Hyperstone", "Model1", 0x3d5b9ef5, 0xca6ab420),
> >>   	PCMCIA_DEVICE_PROD_ID12("IBM", "microdrive", 0xb569a6e5, 0xa6d76178),
> >>   	PCMCIA_DEVICE_PROD_ID12("IBM", "IBM17JSSFP20", 0xb569a6e5, 0xf2508753),
> >> +	PCMCIA_DEVICE_PROD_ID12("KINGSTON", "CF CARD 1GB", 0x2e6d1829, 0x3e520e17
> ),
> >> +	PCMCIA_DEVICE_PROD_ID12("KINGSTON", "CF CARD 4GB", 0x2e6d1829, 0x531e7d10
> ),
> >>   	PCMCIA_DEVICE_PROD_ID12("KINGSTON", "CF8GB", 0x2e6d1829, 0xacbe682e),
> >>   	PCMCIA_DEVICE_PROD_ID12("IO DATA", "CBIDE2      ", 0x547e66dc, 0x8671043
> b),
> >>   	PCMCIA_DEVICE_PROD_ID12("IO DATA", "PCIDE", 0x547e66dc, 0x5c5ab149),
> >> @@ -429,6 +431,8 @@ static struct pcmcia_device_id ide_ids[] = {
> >>   	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS1GCF80", 0x709b1bf1, 0x2a54d4b1)
> ,
> >>   	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS2GCF120", 0x709b1bf1, 0x969aa4f2
> ),
> >>   	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS4GCF120", 0x709b1bf1, 0xf54a91c8
> ),
> >> +	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS4GCF133", 0x709b1bf1, 0x9351e59d)
> ,
> >> +	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS8GCF133", 0x709b1bf1, 0xb2f89b47)
> ,
> >>   	PCMCIA_DEVICE_PROD_ID12("WIT", "IDE16", 0x244e5994, 0x3e232852),
> >>   	PCMCIA_DEVICE_PROD_ID12("WEIDA", "TWTTI", 0xcc7cf69c, 0x212bb918),
> >>   	PCMCIA_DEVICE_PROD_ID1("STI Flash", 0xe4a13209),
> >> diff --git a/drivers/ata/pata_pcmcia.c b/drivers/ata/pata_pcmcia.c
> >> index 3c3172d..4164dd2 100644
> >> --- a/drivers/ata/pata_pcmcia.c
> >> +++ b/drivers/ata/pata_pcmcia.c
> >> @@ -424,6 +424,8 @@ static struct pcmcia_device_id pcmcia_devices[] = {
> >>   	PCMCIA_DEVICE_PROD_ID12("Hyperstone", "Model1", 0x3d5b9ef5, 0xca6ab420),
> >>   	PCMCIA_DEVICE_PROD_ID12("IBM", "microdrive", 0xb569a6e5, 0xa6d76178),
> >>   	PCMCIA_DEVICE_PROD_ID12("IBM", "IBM17JSSFP20", 0xb569a6e5, 0xf2508753),
> >> +	PCMCIA_DEVICE_PROD_ID12("KINGSTON", "CF CARD 1GB", 0x2e6d1829, 0x3e520e17
> ),
> >> +	PCMCIA_DEVICE_PROD_ID12("KINGSTON", "CF CARD 4GB", 0x2e6d1829, 0x531e7d10
> ),
> >>   	PCMCIA_DEVICE_PROD_ID12("KINGSTON", "CF8GB", 0x2e6d1829, 0xacbe682e),
> >>   	PCMCIA_DEVICE_PROD_ID12("IO DATA", "CBIDE2      ", 0x547e66dc, 0x8671043
> b),
> >>   	PCMCIA_DEVICE_PROD_ID12("IO DATA", "PCIDE", 0x547e66dc, 0x5c5ab149),
> >> @@ -444,6 +446,8 @@ static struct pcmcia_device_id pcmcia_devices[] = {
> >>   	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS1GCF80", 0x709b1bf1, 0x2a54d4b1)
> ,
> >>   	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS2GCF120", 0x709b1bf1, 0x969aa4f2
> ),
> >>   	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS4GCF120", 0x709b1bf1, 0xf54a91c8
> ),
> >> +	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS4GCF133", 0x709b1bf1, 0x9351e59d)
> ,
> >> +	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS8GCF133", 0x709b1bf1, 0xb2f89b47)
> ,
> >>   	PCMCIA_DEVICE_PROD_ID12("WIT", "IDE16", 0x244e5994, 0x3e232852),
> >>   	PCMCIA_DEVICE_PROD_ID12("WEIDA", "TWTTI", 0xcc7cf69c, 0x212bb918),
> >>   	PCMCIA_DEVICE_PROD_ID1("STI Flash", 0xe4a13209),
> >>
> 
> Best Regards
> Komuro
