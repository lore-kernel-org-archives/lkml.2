Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab0D1D5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 23:57:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49525 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753717Ab0D1D5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 23:57:41 -0400
Message-ID: <4BD7B177.9020003@cn.fujitsu.com>
Date: Wed, 28 Apr 2010 11:54:31 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 0/10] KVM MMU: allow more shadow pages become asynchronous
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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


