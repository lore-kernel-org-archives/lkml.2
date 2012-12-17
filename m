Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab2LQUkP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 15:40:15 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52895 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278Ab2LQUkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 15:40:13 -0500
Date: Mon, 17 Dec 2012 21:40:11 +0100
From: Borislav Petkov <bp@alien8.de>
To: Joe Perches <joe@perches.com>
Cc: Jacob Shin <jacob.shin@amd.com>, Doug Thompson <dougthompson@xmission.com>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] MCE, AMD: Make MC2 decoding part of amd_decoder_ops
 as well
Message-ID: <20121217204011.GH31866@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Joe Perches <joe@perches.com>, Jacob Shin <jacob.shin@amd.com>,
	Doug Thompson <dougthompson@xmission.com>,
	linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1355773188-5241-1-git-send-email-jacob.shin@amd.com>
 <1355774221.13361.48.camel@joe-AO722>
 <20121217200535.GF31866@liondog.tnic>
 <1355775376.19706.1.camel@joe-AO722>
 <20121217202214.GG31866@liondog.tnic>
 <1355776475.19706.6.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1355776475.19706.6.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 12:34:35PM -0800, Joe Perches wrote:
> decode_mc2_mce does
> 
> 	pr_emerg(HW_ERR "MC2 Error: ");
> calls
> 	fam_ops->mc2_mce()
> which may not emit anything
> and if it doesn't, does
> 	pr_emerg(HW_ERR "Corrupted ...");
> on another line leaving a trailing colon without
> newline from the pr_emerg above.

Ok, this is in Jacob's patch AFAICT, I'll review those tomorrow but
thanks for the heads-up.

> I believe the second pr_emerg should be pr_cont

Actually, it should be

pr_emerg(HW_ERR "\nCorrupted...\n");

to finish the initial pr_emerg.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
