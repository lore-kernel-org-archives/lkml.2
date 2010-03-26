Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab0CZWK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 18:10:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:6786 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213Ab0CZWK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 18:10:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,316,1267430400"; 
   d="scan'208";a="504086166"
From: Ossama Othman <ossama.othman@intel.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Cc: Ossama Othman <ossama.othman@intel.com>
Subject: [PATCH] staging: Initial memrar ABI document
Date: Fri, 26 Mar 2010 15:11:11 -0700
Message-Id: <1269641471-15406-1-git-send-email-ossama.othman@intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20100319225608.GA13174@suse.de>
References: <20100319225608.GA13174@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ossama Othman <ossama.othman@intel.com>
---
 drivers/staging/memrar/memrar-abi |   89 +++++++++++++++++++++++++++++++++++++
 1 files changed, 89 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/memrar/memrar-abi

diff --git a/drivers/staging/memrar/memrar-abi b/drivers/staging/memrar/memrar-abi
new file mode 100644
index 0000000..98a6bb1
--- /dev/null
+++ b/drivers/staging/memrar/memrar-abi
@@ -0,0 +1,89 @@
+What:		/dev/memrar
+Date:		March 2010
+KernelVersion:	Kernel version this feature first showed up in.
+Contact:	Ossama Othman <ossama.othman@intel.com>
+Description:	The Intel Moorestown Restricted Access Region (RAR)
+		Handler driver exposes an ioctl() based interface that
+		allows a user to reserve and release blocks of RAR
+		memory.
+
+		Note:  A sysfs based one was not appropriate for the
+		RAR handler's usage model.
+
+		=========================================================
+				ioctl() Requests
+		=========================================================
+		RAR_HANDLER_RESERVE
+		-------------------
+		Description:	Reserve RAR block.
+		Type:		struct RAR_block_info
+		Direction:	in/out
+		Errors:		EINVAL (invalid RAR type or size)
+				ENOMEM (not enough RAR memory)
+
+		RAR_HANDLER_STAT
+		----------------
+		Description:	Get RAR statistics.
+		Type:		struct RAR_stat
+		Direction:	in/out
+		Errors:		EINVAL (invalid RAR type)
+
+		RAR_HANDLER_RELEASE
+		-------------------
+		Description:	Release previously reserved RAR block.
+		Type:		32 bit unsigned integer
+				(e.g. uint32_t), i.e the RAR "handle".
+		Direction:	in
+		Errors:		EINVAL (invalid RAR handle)
+
+
+		=========================================================
+			ioctl() Request Parameter Types
+		=========================================================
+		The structures referred to above are defined as
+		follows:
+
+		/**
+		 * struct RAR_block_info - user space struct that
+		 *			   describes RAR buffer
+		 * @type:	Type of RAR memory (e.g.,
+		 *		RAR_TYPE_VIDEO or RAR_TYPE_AUDIO) [in]
+		 * @size:	Requested size of a block in bytes to
+		 *		be reserved in RAR. [in]
+		 * @handle:	Handle that can be used to refer to
+		 *		reserved block. [out]
+		 *
+		 * This is the basic structure exposed to the user
+		 * space that describes a given RAR buffer.  It used
+		 * as the parameter for the RAR_HANDLER_RESERVE ioctl.
+		 * The buffer's underlying bus address is not exposed
+		 * to the user.  User space code refers to the buffer
+		 * entirely by "handle".
+		 */
+		struct RAR_block_info {
+			__u32 type;
+			__u32 size;
+			__u32 handle;
+		};
+
+		/**
+		 * struct RAR_stat - RAR statistics structure
+		 * @type:		Type of RAR memory (e.g.,
+		 *			RAR_TYPE_VIDEO or
+		 *			RAR_TYPE_AUDIO) [in]
+		 * @capacity:		Total size of RAR memory
+		 *			region. [out]
+		 * @largest_block_size:	Size of the largest reservable
+		 *			block. [out]
+		 *
+		 * This structure is used for RAR_HANDLER_STAT ioctl.
+		 */
+		struct RAR_stat {
+			__u32 type;
+			__u32 capacity;
+			__u32 largest_block_size;
+		};
+
+		Lastly, the RAR_HANDLER_RELEASE ioctl expects a
+		"handle" to the RAR block of memory.  It is a 32 bit
+		unsigned integer.
-- 
1.6.3.3

