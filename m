Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312Ab2HQXnZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 19:43:25 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:35505 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211Ab2HQXnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 19:43:17 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Date: Sat, 18 Aug 2012 00:43:15 +0100
From: Tony Finch <dot@dotat.at>
X-X-Sender: fanf2@hermes-1.csi.cam.ac.uk
To: Jesper Juhl <jj@chaosbits.net>
cc: linux-kernel@vger.kernel.org, Tony Finch <dot@dotat.at>
Subject: Re: [PATCH] unifdef: set a secure umask before calling mkstemp()
In-Reply-To: <alpine.LNX.2.00.1208172136490.15699@swampdragon.chaosbits.net>
Message-ID: <alpine.LSU.2.00.1208180025311.29492@hermes-1.csi.cam.ac.uk>
References: <alpine.LNX.2.00.1208172136490.15699@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl <jj@chaosbits.net> wrote:

> In newer glibc's (versions > 2.06) reasonably secure permissions of
> 0600 are used when creating a temporary file with mkstemp(). But for
> older glibc's (versions <= 2.06) 0666 is used which is not secure.

Thanks for your suggestion! I'm afraid I prefer not to make the change.

Unifdef is only using mkstemp as a convenient way to open a file with a
non-clashing name. It isn't trying to be secure, so it's OK just to rely
on the user's umask. And I find it hard to care about a bug that was fixed
15 years ago.

I'm also trying to reduce the unixisms in the program for portability
reasons and this is the most awkward part :-/

Tony.
-- 
f.anthony.n.finch  <dot@dotat.at>  http://dotat.at/
Forties, Cromarty: East, veering southeast, 4 or 5, occasionally 6 at first.
Rough, becoming slight or moderate. Showers, rain at first. Moderate or good,
occasionally poor at first.
