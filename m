Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687Ab1ADF77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 00:59:59 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63205 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab1ADF75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 00:59:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=E2St5MunWjs+IuJkXdnszOH46PVIG0L9ipbTZJAT9p/Kp8b91cYSdt7ZGow2CBgPIa
         QYfCd2Xqvyh6xg9w0HiM6iI1aZSu6w/DcMfYGIXoYv6sWA8S4kpVmsh+1v/VeZCVtF2g
         0qhQZjyYGsCdurLyF5HlvtVqWLSaPzIjxC1fQ=
Date: Tue, 4 Jan 2011 08:59:00 +0300
From: Dan Carpenter <error27@gmail.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        joe@perches.com
Subject: [patch] checkpatch: putting the && or || on the wrong line
Message-ID: <20110104055900.GA5062@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org, joe@perches.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes checkpatch.pl complain if you break up conditions in
the wrong way.

Wrong:
	if ((really_long_condition)
		&& (second_condition)) { ...
Right:
	if ((really_long_condition) &&
		(second_condition)) { ...

If you do it in the wrong way the message is:  "put the && or || at the
end of the previous line"

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index e3c7fc0..0a813db 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1509,6 +1509,11 @@ sub process {
 			WARN("please, no space before tabs\n" . $herevet);
 		}
 
+# check for && or || at the start of a line
+		if ($rawline =~ /^\+\W+(&&|\|\|)/) {
+			WARN("put the && or || at the end of the previous line\n" . $herecurr);
+		}
+
 # check for spaces at the beginning of a line.
 # Exceptions:
 #  1) within comments
