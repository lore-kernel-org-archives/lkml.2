Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab2CMSic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 14:38:32 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:39595 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753222Ab2CMSia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 14:38:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=Q1Gt8SFANch+dhjvwGAKDSHM8df2mDlW
	6kq09uTZHN+lekUk6xvjlXXuYBelwIXhhCVVlMVcqDpTcE94/GPUk/4AALGBACKX
	WDtzTrlhATdPwoAuA62yUz3P3TWK1aN1DiCHL9ixDMp6xBkgGN+Qrn9PY2uo2xHs
	via8e6xn4gQ=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Cc: Jonathan Nieder <jrnieder@gmail.com>, Thomas Rast <trast@student.ethz.ch>,
        Willy Tarreau <w@1wt.eu>, Greg KH <greg@kroah.com>,
        Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH] git-am: officially deprecate -b/--binary
References: <20120312152453.GB12405@1wt.eu>
 <87aa3l4vqq.fsf@thomas.inf.ethz.ch> <20120312165703.GB18791@burratino>
 <7vvcm9snko.fsf@alter.siamese.dyndns.org> <87399dpk48.fsf@thomas.inf.ethz.ch>
 <20120312215607.GB11362@burratino> <874ntto4t8.fsf@thomas.inf.ethz.ch>
 <20120312222227.GC11362@burratino> <87fwdcldqj.fsf@thomas.inf.ethz.ch>
 <7v62e8la9y.fsf@alter.siamese.dyndns.org> <20120313175158.GA6653@burratino>
 <7vipi8wect.fsf@alter.siamese.dyndns.org>
Date: Tue, 13 Mar 2012 11:38:27 -0700
In-Reply-To: <7vipi8wect.fsf@alter.siamese.dyndns.org> (Junio C. Hamano's
 message of "Tue, 13 Mar 2012 11:22:10 -0700")
Message-ID: <7vsjhcuz18.fsf_-_@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: BA1C2F8C-6D3B-11E1-B56D-9DB42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have had these options as harmless no-op for more than 3 years without
officially deprecating them.  Let's announce the deprecation and start
warning against their use, but without failing the command just not yet,
so that we can later repurpose the option if we want to in the future.

Signed-off-by: Junio C Hamano <gitster@pobox.com>
---
 Documentation/RelNotes/1.7.10.txt |    4 ++--
 git-am.sh                         |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/RelNotes/1.7.10.txt b/Documentation/RelNotes/1.7.10.txt
index 65df74b..6286485 100644
--- a/Documentation/RelNotes/1.7.10.txt
+++ b/Documentation/RelNotes/1.7.10.txt
@@ -26,8 +26,8 @@ Compatibility Notes
    Git v1.7.8 or newer.
 
  * The "--binary/-b" options to "git am" have been a no-op for quite a
-   while and was deprecated in mid 2008 (v1.6.0).  When you give these
-   options to "git am", it will now fail with an error.
+   while and were deprecated in mid 2008 (v1.6.0).  When you give these
+   options to "git am", it will now warn and ask you not to use them.
 
 
 Updates since v1.7.9
diff --git a/git-am.sh b/git-am.sh
index faae820..db6ade3 100755
--- a/git-am.sh
+++ b/git-am.sh
@@ -380,8 +380,8 @@ do
 	-i|--interactive)
 		interactive=t ;;
 	-b|--binary)
-		echo >&2 "The -b/--binary option was deprecated in 1.6.0 and removed in 1.7.10."
-		die "Please adjust your scripts."
+		echo >&2 "The $1 option was deprecated in 1.6.0 and will be removed."
+		echo >&2 "Please do not use it anymore."
 		;;
 	-3|--3way)
 		threeway=t ;;
