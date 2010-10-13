Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab0JMUq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 16:46:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683Ab0JMUq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 16:46:26 -0400
Message-ID: <4CB61A7F.9070603@redhat.com>
Date: Wed, 13 Oct 2010 22:45:51 +0200
From: Edward Shishkin <edward@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org
CC: Eric Sandeen <sandeen@redhat.com>, lmcilroy@redhat.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: [patch 0/2][RFC] vfs: artefact(?) in rw_verify_area
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone.

rw_verify_area() contains a limitation, which means inability
to write more then INT_MAX bytes atomically. This tends
to be a disadvantage since INT_MAX doesn't look like a huge
value nowadays. Moreover, this restriction looks too artificial.

I have increased the limit up to rounded down SSIZE_MAX
(patch 2) and got an overflow in the direct-io subsystem.
However, after fixing the overflow (patch 1), ext3,4 work
fine for me so far.

Any ideas, if there are other subsystems that expose the
INT_MAX limitation?

Thanks in advance,

-- 
Edward O. Shishkin
Principal Software Engineer
Red Hat Czech

