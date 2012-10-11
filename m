Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758542Ab2JKQSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 12:18:16 -0400
Received: from service87.mimecast.com ([91.220.42.44]:32906 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932Ab2JKQSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 12:18:14 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
Subject: [PATCH 0/4] uapi: Allow automatic generation of trivial headers
Date: Thu, 11 Oct 2012 17:18:01 +0100
Message-Id: <1349972285-22830-1-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.12.3
X-OriginalArrivalTime: 11 Oct 2012 16:18:10.0686 (UTC) FILETIME=[01AC79E0:01CDA7CC]
X-MC-Unique: 112101117181200601
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q9BGINOn011847

Hi,

The asm/Kbuild allows automatic generation of header files by specifying
"generic-y += ...". The first patch in the series allows the same thing
to be specified in uapi/asm/Kbuild.

The subsequent patches remove some of the trivial header files in arm64,
s390 and sparc. Please note that the series has only been tested on
arm64. I can test the others but not until tomorrow.


Catalin Marinas (4):
  uapi: Allow automatic generation of uapi/asm/ header files
  arm64: Automatically generate UAPI stat.h and unistd.h headers
  s390: Automatically generate trivial UAPI headers
  sparc: Automatically generate trivial UAPI headers

 Makefile                               |  4 +++-
 arch/arm64/include/uapi/asm/Kbuild     |  5 +++--
 arch/arm64/include/uapi/asm/stat.h     | 16 ----------------
 arch/arm64/include/uapi/asm/unistd.h   | 16 ----------------
 arch/s390/include/uapi/asm/Kbuild      | 19 ++++++++++---------
 arch/s390/include/uapi/asm/errno.h     | 11 -----------
 arch/s390/include/uapi/asm/fcntl.h     |  1 -
 arch/s390/include/uapi/asm/ioctl.h     |  1 -
 arch/s390/include/uapi/asm/mman.h      |  6 ------
 arch/s390/include/uapi/asm/param.h     |  6 ------
 arch/s390/include/uapi/asm/poll.h      |  1 -
 arch/s390/include/uapi/asm/resource.h  | 13 -------------
 arch/s390/include/uapi/asm/sockios.h   |  6 ------
 arch/s390/include/uapi/asm/termbits.h  |  6 ------
 arch/sparc/include/uapi/asm/Kbuild     |  5 +++--
 arch/sparc/include/uapi/asm/kvm_para.h |  1 -
 arch/sparc/include/uapi/asm/statfs.h   |  6 ------
 scripts/Makefile.asm-generic           |  2 +-
 18 files changed, 20 insertions(+), 105 deletions(-)
 delete mode 100644 arch/arm64/include/uapi/asm/stat.h
 delete mode 100644 arch/arm64/include/uapi/asm/unistd.h
 delete mode 100644 arch/s390/include/uapi/asm/errno.h
 delete mode 100644 arch/s390/include/uapi/asm/fcntl.h
 delete mode 100644 arch/s390/include/uapi/asm/ioctl.h
 delete mode 100644 arch/s390/include/uapi/asm/mman.h
 delete mode 100644 arch/s390/include/uapi/asm/param.h
 delete mode 100644 arch/s390/include/uapi/asm/poll.h
 delete mode 100644 arch/s390/include/uapi/asm/resource.h
 delete mode 100644 arch/s390/include/uapi/asm/sockios.h
 delete mode 100644 arch/s390/include/uapi/asm/termbits.h
 delete mode 100644 arch/sparc/include/uapi/asm/kvm_para.h
 delete mode 100644 arch/sparc/include/uapi/asm/statfs.h


