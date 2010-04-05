Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990Ab0DEXsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 19:48:13 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:63417 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757Ab0DEXsJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 19:48:09 -0400
MIME-Version: 1.0
In-Reply-To: <20100405230301.GF32401@fluff.org.uk>
References: <20100311174830.4824.19820.stgit@angua> <20100311180649.4824.10368.stgit@angua> 
	<20100405230301.GF32401@fluff.org.uk>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 5 Apr 2010 17:47:48 -0600
X-Google-Sender-Auth: d194c4a98b8ece7e
Message-ID: <q2tfa686aa41004051647p4c8182d0h807583d09714761a@mail.gmail.com>
Subject: Re: [PATCH 33/37] sound/soc: use .dev.of_node instead of .node in 
	struct of_device
To: Ben Dooks <ben-linux@fluff.org>
Cc: monstr@monstr.eu, gregkh@suse.de, benh@kernel.crashing.org,
       akpm@linux-foundation.org, davem@davemloft.net, sfr@canb.auug.org.au,
       jgarzik@pobox.com, dwmw2@infradead.org, jeremy.kerr@canonical.com,
       James.Bottomley@suse.de, broonie@opensource.wolfsonmicro.com,
       microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org,
       linux-ide@vger.kernel.org, netdev@vger.kernel.org,
       linux-i2c@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
       linux-scsi@vger.kernel.org, alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben, thanks for the comment.  Reply below...

On Mon, Apr 5, 2010 at 5:03 PM, Ben Dooks <ben-linux@fluff.org> wrote:
> On Thu, Mar 11, 2010 at 11:06:50AM -0700, Grant Likely wrote:
>> .node is being removed
[...]
>> --- a/sound/soc/fsl/mpc8610_hpcd.c
>> +++ b/sound/soc/fsl/mpc8610_hpcd.c
>> @@ -202,7 +202,7 @@ static struct snd_soc_ops mpc8610_hpcd_ops = {
>>  static int mpc8610_hpcd_probe(struct of_device *ofdev,
>>       const struct of_device_id *match)
>>  {
>> -     struct device_node *np = ofdev->node;
>> +     struct device_node *np = ofdev->dev.of_node;
>>       struct device_node *codec_np = NULL;
>>       struct device_node *guts_np = NULL;
>>       struct device_node *dma_np = NULL;
>
> This looks like one case where an inline function would have been a
> help.

In what regard (how would you like it to look)?  The node pointer
location is very unlikely to move again, and I prefer the clarity of
direct dereferencing.

g.
