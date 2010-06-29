Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab0F2MoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 08:44:23 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56191 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab0F2MoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 08:44:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=kDeNDnsUkTz/ofm9yR+tudyxQU8gjaHMO236GI1H+KEQ5F9Sv0FcdO8yYJzMh7mZf6
         0cMQrsR2GKvmfrTJRBdvgc00XhJKfc+De1EBhyaw1efOrY5XF9JfNZyXxgtR6BOTMm5v
         PdIznaZwOk7oYsETjGn+EXnh3ja3bgyx8rCKA=
Date: Tue, 29 Jun 2010 16:44:15 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: Rupjyoti Sarmah <rsarmah@amcc.com>, linux-ide@vger.kernel.org, sr@denx.de,
       jgarzik@pobox.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH]460EX on-chip SATA driver<kernel 2.6.33><resubmission>
Message-ID: <20100629124415.GA32738@oksana.dev.rtsoft.ru>
References: <201006041226.o54CQH2V017366@amcc.com>
 <201006290333.50673.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201006290333.50673.marek.vasut@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 03:33:50AM +0200, Marek Vasut wrote:
> Dne Pá 4. června 2010 14:26:17 Rupjyoti Sarmah napsal(a):
> > This patch enables the on-chip DWC SATA controller of the AppliedMicro
> > processor 460EX.
> > 
> > Signed-off-by: Rupjyoti Sarmah <rsarmah@appliedmicro.com>
> > Signed-off-by: Mark Miesfeld <mmiesfeld@appliedmicro.com>
> > Signed-off-by: Prodyut Hazarika <phazarika@appliedmicro.com>
> > 
> 
> --SNIP--
> 
> > +		dev_err(ap->dev, "%s: Command not pending cmd_issued=%d "
> > +			"(tag=%d) DMA NOT started\n", __func__,
> > +			hsdevp->cmd_issued[tag], tag);
> 
> Just a nitpick, but don't break strings if possible.

Note that in this particular case breaking strings was OK, and
was actually done in a clever manner.

That is, I doubt that anyone grep for error messages with
regexps, so grep "Command not pending" or grep "DMA NOT started"
would work.

This makes the code more readable (literally, because you don't
have to scroll to see dev_err's arguments) without sacrificing
grep'ability.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
