Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab0EFJd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 05:33:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51565 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751606Ab0EFJd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 05:33:27 -0400
Message-ID: <4BE28C2A.1050809@cn.fujitsu.com>
Date: Thu, 06 May 2010 17:30:18 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 0/9] KVM MMU: allow more shadow pages become asynchronous
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changlog v4:

- fix the bug that reported by Marcelo

- fix the race in invlpg code

Changlog v3:

Those changes all form Avi's suggestion, thanks.

- use smart way to fix the bug in patch 1
- remove duplicates code in patch 5
- check error code and fix forgot release page in patch 9
- sync shadow pages in a batch instead of one by one

And, there is one TODO thing:
Marker shadow page as unsync at create time avoid write-protect,
this idea is from Avi:

|Another interesting case is to create new shadow pages in the unsync state.
|That can help when the guest starts a short lived process: we can avoid write
|protecting its pagetables completely

I'll send the patch out after this patchset applied.
 
Changlog v2:

- when level is PT_DIRECTORY_LEVEL, the 'offset' should be
  'role.quadrant << 8', thanks Avi for point it out

- keep invlpg code in paging_tmpl.h address Avi's suggestion

- split kvm_sync_page() into kvm_sync_page() and kvm_sync_page_transient()
  to clarify the code address Avi's suggestion








