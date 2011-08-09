Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab1HIO2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 10:28:31 -0400
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:46700 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752499Ab1HIO22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 10:28:28 -0400
X-AuditID: 1209190e-b7c22ae000000a2c-df-4e41439f58fc
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: Andy Lutomirski <luto@MIT.EDU>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, lueckintel@yahoo.com,
        kimwooyoung@gmail.com, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <bp@alien8.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 4/4] Add vsyscalls to feature-removal-schedule.txt
Date: Tue,  9 Aug 2011 10:27:50 -0400
Message-Id: <066852f3f344c1733e0db9a2427981ea1815db7d.1312899174.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1312899174.git.luto@mit.edu>
References: <cover.1312899174.git.luto@mit.edu>
In-Reply-To: <cover.1312899174.git.luto@mit.edu>
References: <cover.1312899174.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRmVeSWpSXmKPExsUixG6nrjvf2dHPYHubhEXflaPsFkeufWe3
	+LzhH5vFtI3iFq/+lFtc3jWHzWLF+U5Wiy2Xmlkt/jXdYrF41PeW3eLHhsesDtwe31v7WDxu
	tf1h9pi/8yOjx85Zd9k9Fu95yeSxaVUnm8eJGb9ZPD5vkvOYNeswk8eJli+sAVxRXDYpqTmZ
	ZalF+nYJXBkPVl1gLVjNXdH17QNLA+Nmzi5GTg4JAROJgz072SFsMYkL99azdTFycQgJ7GOU
	uNFwmQnCWc8o8XLuN0aQKiGBp0wSDaf1QWw2ARWJjqUPgIo4OEQEhCSW3q0DqWcGKWmes5sZ
	pEZYwEmid+1ssF4WAVWJ6V0r2UDqeQWCJE6vNYJYLCdx5PJzJhCbU8BA4sfnu0wQq/Ql1p+4
	iFN8AqPAAkaGVYyyKblVurmJmTnFqcm6xcmJeXmpRbrGermZJXqpKaWbGEExwCnJt4Px60Gl
	Q4wCHIxKPLyc/A5+QqyJZcWVuYcYJTmYlER5i4ARJMSXlJ9SmZFYnBFfVJqTWnyIUYKDWUmE
	N10DKMebklhZlVqUD5OS5mBREuddvQNokkB6YklqdmpqQWoRTFaGg0NJgrcPZKhgUWp6akVa
	Zk4JQpqJgxNkOA/Q8ConkOHFBYm5xZnpEPlTjIpS4rxRIM0CIImM0jy4XliKesUoDvSKMG8W
	SBUPML3Bdb8CGswENLj+jgPI4JJEhJRUA6Pl4smXTGZJT+12un8onsM1zmjTBeb+uN/zoy+Z
	X3xq9FNG7DqjzSS+ovi0d0sr6058CPM6O1ct7YwG33l+i6kJf7aYd8WunFmk3tb/e3nUuXva
	/22Ke3OYv9wX2WvqtYjrvcj+X4ZL0pgtjz7TX1qkOLdDisU9xfFN3JVrB3xW9TglxMm4zlJi
	Kc5INNRiLipOBADJnsT1LAMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a couple years, we'll see how well we've done at eradicating vsyscall-using
binaries.  Hopefully we can then disable them by default.  We will probably
have to leave the option to enable them around forever.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 Documentation/feature-removal-schedule.txt |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 43f4809..981562f 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -575,6 +575,20 @@ Who:	Hans Verkuil <hans.verkuil@cisco.com>
 
 ----------------------------
 
+What:	vsyscalls may go away by default
+When:	3.6
+Why:	All vsyscall functionality is available as regular syscalls and through
+	the vDSO.  Vsyscalls are currently emulated and are slower than normal
+	syscalls.  Userspace exploits can still use the emulated vsyscall traps
+	as a form of 'ret' instruction.
+	
+	In the mean time, do *not* rely on the semantics of int 0x40, int 0x41,
+	and int 0x42.  They may change or go away completely with no notice.
+	Any attempt to use them will result in a warning in the kernel log.
+Who:	Andy Lutomirski <luto@mit.edu>
+
+----------------------------
+
 What:	g_file_storage driver
 When:	3.8
 Why:	This driver has been superseded by g_mass_storage.
-- 
1.7.6

