Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315Ab2A3LSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 06:18:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38604 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab2A3LSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 06:18:20 -0500
Date: Mon, 30 Jan 2012 11:18:17 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: checkpatch.pl: WxV false positive
Message-ID: <20120130111817.GA18810@localhost>
References: <20120122214834.6414592c@lenov0n>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120122214834.6414592c@lenov0n>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 22, 2012 at 09:48:34PM -0500, Vivien Didelot wrote:

> In the code below, checkpatch thinks that the asterisk is a
> multiplication, so it is complaining about coding style.
> 
>     ERROR: need consistent spacing around '*' (ctx:WxV)
>     #304: FILE: x86/platform/ts5500/ts5500_adc.c:304:
>     +	.attrs = (struct attribute *[]) {

C types are the pits.  How does the version below handle for you:

    http://people.canonical.com/~apw/checkpatch/checkpatch-next.pl

Relative patch below.

-apw

commit f8a73045dcaac70f9be770cca06f21c762a13878
Author: Andy Whitcroft <apw@canonical.com>
Date:   Sun Jan 29 21:46:04 2012 +0000

    checkpatch: add [] to type extensions
    
    Add [] to a type extensions.  Fixes false positives on:
    
        .attrs = (struct attribute *[]) {
    
    Signed-off-by: Andy Whitcroft <apw@canonical.com>

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index d1dd544..64de1bd 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -323,7 +323,7 @@ sub build_types {
 		  }x;
 	$Type	= qr{
 			$NonptrType
-			(?:[\s\*]+\s*const|[\s\*]+|(?:\s*\[\s*\])+)?
+			(?:(?:\s|\*|\[\])+\s*const|(?:\s|\*|\[\])+|(?:\s*\[\s*\])+)?
 			(?:\s+$Inline|\s+$Modifier)*
 		  }x;
 	$Declare	= qr{(?:$Storage\s+)?$Type};
