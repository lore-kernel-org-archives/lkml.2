Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab2A0U2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 15:28:19 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48699 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab2A0U2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 15:28:18 -0500
Message-ID: <4F230903.5080504@jp.fujitsu.com>
Date: Fri, 27 Jan 2012 15:28:51 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: keescook@chromium.org
CC: gorcunov@openvz.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, ebiederm@xmission.com, xemul@openvz.org,
        mtk.manpages@gmail.com, tj@kernel.org, avagin@openvz.org,
        serge.hallyn@canonical.com, xemul@parallels.com, segoon@openwall.com,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [RFC c/r 4/4] c/r: prctl: Extend PR_SET_MM to set up more mm_struct
 entries
References: <20120127175342.273260614@openvz.org> <20120127175939.928628374@openvz.org> <CAGXu5jJtBJGt-8iLrC5Jg9N0K2zeYxDtt8uZojY41osejV_aKg@mail.gmail.com>
In-Reply-To: <CAGXu5jJtBJGt-8iLrC5Jg9N0K2zeYxDtt8uZojY41osejV_aKg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +
>> +       case PR_SET_MM_AUXV:
>> +               if (arg4 > sizeof(mm->saved_auxv))
>> +                       goto out;
>> +               up_read(&mm->mmap_sem);
>> +
>> +               error = -EFAULT;
>> +               if (!copy_from_user(mm->saved_auxv, (const void __user *)addr, arg4))
>> +                       error = 0;
>> +
>> +               return error;
> 
> Is the mmap_sem released here because of the copy_from_user()? Is it
> still safe to write to saved_auxv?

Sure. It's unsafe.

