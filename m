Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab2FMSJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 14:09:27 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:2202 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754507Ab2FMSJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 14:09:26 -0400
Message-ID: <1339610958.30984.158.camel@x61.thuisdomein>
Subject: scripts/get_maintainer.pl --help prints a warning
From: Paul Bolle <pebolle@tiscali.nl>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 13 Jun 2012 20:09:18 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 13 Jun 2012 18:09:18.0444 (UTC) FILETIME=[A6659AC0:01CD498F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0) "scripts/get_maintainer.pl --help" prints a warning (to stderr):
Use of uninitialized value $signature_pattern in concatenation (.) or
string at scripts/get_maintainer.pl line 723.

1) That must be caused by line 732:
        or use only ${signature_pattern} signers (default: $email_git_all_signature_types)

2) "git blame -L 732,+1 scripts/get_maintainer.pl" points to commit
683c6f8fcbcb6de8d07545ba70aff49e50d8bcf2 ("scripts/get_maintainer.pl:
improve --interactive UI"). And a quick look at that commit suggests it
introduced (most of) the current usage of $signature_pattern.

3) Would you have an idea how to silence that warning?


Paul Bolle

