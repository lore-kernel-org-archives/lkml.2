Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab2LQUeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 15:34:37 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:52590 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753155Ab2LQUeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 15:34:36 -0500
Message-ID: <1355776475.19706.6.camel@joe-AO722>
Subject: Re: [PATCH 1/2] MCE, AMD: Make MC2 decoding part of amd_decoder_ops
 as well
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Jacob Shin <jacob.shin@amd.com>, Doug Thompson <dougthompson@xmission.com>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 17 Dec 2012 12:34:35 -0800
In-Reply-To: <20121217202214.GG31866@liondog.tnic>
References: <1355773188-5241-1-git-send-email-jacob.shin@amd.com>
	 <1355774221.13361.48.camel@joe-AO722> <20121217200535.GF31866@liondog.tnic>
	 <1355775376.19706.1.camel@joe-AO722> <20121217202214.GG31866@liondog.tnic>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-17 at 21:22 +0100, Borislav Petkov wrote:
> On Mon, Dec 17, 2012 at 12:16:16PM -0800, Joe Perches wrote:
> > You also have paths where you start a pr_emerg and do not terminate it
> > when there is no apparent error at all.
> 
> For example?
> 

decode_mc2_mce does

	pr_emerg(HW_ERR "MC2 Error: ");
calls
	fam_ops->mc2_mce()
which may not emit anything
and if it doesn't, does
	pr_emerg(HW_ERR "Corrupted ...");
on another line leaving a trailing colon without
newline from the pr_emerg above.

I believe the second pr_emerg should be pr_cont

cheers, Joe

