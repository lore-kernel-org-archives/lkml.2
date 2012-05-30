Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929Ab2E3Tl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 15:41:29 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:25129 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752423Ab2E3Tl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 15:41:27 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: .fMULSMVM1kWiqLiXknq.Z7VVcJ5yHw_xh1hm4DorI0g1W7
 sUNVNG6af.YxLDLhASK5IlFRffhM42uOoQ9sSr6PbiEdUuc0EB.YdCyC7U7C
 TCwKPdOPej9sK.rVqj9OKzkQXwfITWi3WMcblIyInKbCAtDVi2waV9hzrCOK
 5gWqwHKEqtxjNoOvFCPUFYL8KmAb.Fcsjd0ybCFPRBXN6CyuPRa6iYUdjgcM
 J99MsWN9nkrD2G7IotHvTfYDdsAoJQHS1uMPVqH4xBb0kqbLX4YyQKkdjCjL
 3RdPJagJVaQsi3dCqKlwDnokZLRzOXseVFMWCM9HlUqRPmCGShgtsm7SEp.W
 3QU6z.ldS1ElUXTFLcjaaI_HtzNYuwztSihk.K_JTkuunwibDMJmp6cpvM_s
 rsynwGsLipU_KK10FJkizxzmdfylOmBhuevcQ
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 30 May 2012 14:41:22 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: kosaki.motohiro@gmail.com
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@google.com>, Dave Jones <davej@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, stable@vger.kernel.org,
        hughd@google.com, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, andi@firstfloor.org
Subject: Re: [PATCH 2/6] mempolicy: Kill all mempolicy sharing
In-Reply-To: <1338368529-21784-3-git-send-email-kosaki.motohiro@gmail.com>
Message-ID: <alpine.DEB.2.00.1205301439410.31768@router.home>
References: <1338368529-21784-1-git-send-email-kosaki.motohiro@gmail.com> <1338368529-21784-3-git-send-email-kosaki.motohiro@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2012, kosaki.motohiro@gmail.com wrote:

> refcount will be decreased even though was not increased whenever alloc_page_vma()
> is called. As you know, mere mbind(MPOL_MF_MOVE) calls alloc_page_vma().

Most of these issues are about memory migration and shared memory. If we
exempt shared memory from memory migration (after all that shared memory
has its own distinct memory policies already!) then a lot of these issues
wont arise.
