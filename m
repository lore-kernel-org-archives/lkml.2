Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab2LSQKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 11:10:08 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:54569 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454Ab2LSQKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 11:10:05 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v5 7/8] fat (exportfs): rebuild directory-inode if fat_dget() fails
References: <1353504311-6020-1-git-send-email-linkinjeon@gmail.com>
	<878v9f5ugn.fsf@devron.myhome.or.jp>
	<CAKYAXd-ydXkwDq6vkECEKPUQiNgg2+GKbL+ah9sn+uqr8BT1kQ@mail.gmail.com>
	<87k3sy17vk.fsf@devron.myhome.or.jp>
	<CAKYAXd8=7BG8NsVyvUP5xW48Y9FJpD7M95_MiJVGcwYOfYsrLA@mail.gmail.com>
	<87txs0x45r.fsf@devron.myhome.or.jp>
	<CAKYAXd8OP_FXxJWHESW_bCY1hGQuZPMJYOkLkmQ4fOkDhGO8xw@mail.gmail.com>
	<CAKYAXd9NXVsBTMpTUWxN_10z1Ozt47f6Ghvsv9rbp_Y8tVMg2A@mail.gmail.com>
Date: Thu, 20 Dec 2012 01:10:01 +0900
In-Reply-To: <CAKYAXd9NXVsBTMpTUWxN_10z1Ozt47f6Ghvsv9rbp_Y8tVMg2A@mail.gmail.com>
	(Namjae Jeon's message of "Sat, 15 Dec 2012 19:52:32 +0900")
Message-ID: <87623ydnvq.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

>> Okay, We will check how we can consolidate the 2 paths to avoid any issue.
> Hi OGAWA.
>
> On checking fat_search_long() logic, it is observed that it performs
> name based lookup of the entries in a given directory.
> In fat_get_parent(), we do not have such information to use the
> existing API to reconstruct the  parent inode.
> Could you give me some hint or guide to consolidate smoothly
> fat_search_long and current traverse_logic ?

Hm, start with copy of fat_search_long() and refactoring it. With it, we
will be able to avoid the fixed bugs.

After that, we might be able to merge those somehow. Well, I'm not
pretty sure without doing it actually though.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
