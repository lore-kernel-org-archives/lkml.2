Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab2DSWIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 18:08:50 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55015 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756413Ab2DSWIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 18:08:48 -0400
Message-ID: <4F908CEB.8090606@openvz.org>
Date: Fri, 20 Apr 2012 02:08:43 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Oleg Nesterov <oleg@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "matthltc@us.ibm.com" <matthltc@us.ibm.com>,
        "tj@kernel.org" <tj@kernel.org>, Pavel Emelianov <xemul@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: + c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-
 num_exe_file_vmas-removal.patch added to -mm tree
References: <20120419185221.E8ED6A055E@akpm.mtv.corp.google.com> <20120419192005.GA13558@redhat.com> <20120419210033.GO1893@moon> <20120419211216.GA2200@redhat.com> <20120419213204.GP1893@moon>
In-Reply-To: <20120419213204.GP1893@moon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> On Thu, Apr 19, 2012 at 11:12:16PM +0200, Oleg Nesterov wrote:
>>> Heh :) Oleg, it was actually your idea to make this feature "one-shot".
>>
>> Heh, no ;)
>>
>> IIRC, I only asked you what do you actually want,
>>
>> 	Just one note for the record, prctl_set_mm_exe_file() does
>>
>> 		if (mm->num_exe_file_vmas)
>> 			return -EBUSY;
>>
>> 	We could do
>>
>> 		if (mm->exe_file)
>> 			return -EBUSY;
>>
>> 	This way "because this feature is a special to C/R" becomes
>> 	really true. IOW, you can't do PR_SET_MM_EXE_FILE twice.
>>
>> 	I am fine either way, just I want to ensure you really want
>> 	the current version.
>>
>> and only because it was documented as "feature is a special to C/R".
>
> ok, ubedil :)
>
>>> Once exe-file changed to a new value, it can't be changed again. The
>>> reason was to bring at least minimum disturbance in sysadmins life.
>>
>> You misunderstood. I am not arguing with "one-shot", I do not really
>> care.
>>
>> My question is: unless I missed something "it can't be changed again"
>> is not actually true. A task does PR_SET_MM_EXE_FILE, then it forks
>> the new child. The child can do PR_SET_MM_EXE_FILE again. Is this
>> by design?
>
> Hmm, not sure, Konstantin?

Why not? It has new pid, why it cannot change exe_file? Actually I don't care too.
But even if we include this bit into MMF_INIT_MASK we cannot forbid exe-file change
in childs tasks which was forked before exe-file change in parent.
