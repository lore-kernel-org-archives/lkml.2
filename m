Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab2ABUov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 15:44:51 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56782 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab2ABUot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 15:44:49 -0500
Message-ID: <4F021784.7070802@gmail.com>
Date: Tue, 03 Jan 2012 07:45:56 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
CC: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com,
        joe@perches.com, valdis.kletnieks@vt.edu, jj@chaosbits.net
Subject: Re: [PATCH 6/6] Staging: comedi: fix initialise statics to 0 or NULL
 issue in ni_mio_cs.c.
References: <1325510273-20091-1-git-send-email-ravishankar.km@greenturtles.in>
In-Reply-To: <1325510273-20091-1-git-send-email-ravishankar.km@greenturtles.in>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/12 00:17, Ravishankar karkala Mallikarjunayya wrote:
> This is a patch to the ni_mio_cs.c file that fixes up a initialise
> statics to 0 or NULL warning found by the checkpatch.pl tool.
>
> Breaks the build.

Greg was pointing out that your previous patch broke the build. He did
not literally mean that you should add the above message to the commit
log. The fact that you did, seemingly thinking that doing so was
correct, is just ... scary.

> Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
> ---
>  drivers/staging/comedi/drivers/ni_mio_cs.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/ni_mio_cs.c b/drivers/staging/comedi/drivers/ni_mio_cs.c
> index 53ec24b..cb3d08b 100644
> --- a/drivers/staging/comedi/drivers/ni_mio_cs.c
> +++ b/drivers/staging/comedi/drivers/ni_mio_cs.c
> @@ -258,7 +258,7 @@ static void mio_cs_config(struct pcmcia_device *link);
>  static void cs_release(struct pcmcia_device *link);
>  static void cs_detach(struct pcmcia_device *);
>  
> -static struct pcmcia_device *cur_dev = NULL;
> +static struct pcmcia_device *cur_dev;
>  
>  static int cs_attach(struct pcmcia_device *link)
>  {
> @@ -351,6 +351,8 @@ static int mio_cs_attach(struct comedi_device *dev, struct comedi_devconfig *it)
>  	printk("comedi%d: %s: DAQCard: io 0x%04lx, irq %u, ",
>  	       dev->minor, dev->driver->driver_name, dev->iobase, irq);
>  
> +
> +

Why this change?

>  #if 0
>  	{
>  		int i;
> @@ -400,7 +402,7 @@ static int mio_cs_attach(struct comedi_device *dev, struct comedi_devconfig *it)
>  }
>  
>  static int ni_getboardtype(struct comedi_device *dev,
> -			   struct pcmcia_device *link)
> +		struct pcmcia_device *link)

Why this change?

>  {
>  	int i;
>  

