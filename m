Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab2LKSNG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 13:13:06 -0500
Received: from mga12.intel.com ([143.182.124.36]:17626 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754295Ab2LKSNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 13:13:04 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFxh2SH9WcXbb+hD3PtWa4ZTqYNUxvbqZh27vwANuUTE8w@mail.gmail.com>
References: <cover.1353621075.git.dmitry.kasatkin@intel.com>
	<CALLzPKZKd38QJVPfjdNpAFO9hwmRc1asVGkHby1VGRLm89DKyg@mail.gmail.com>
	<CALLzPKZgxO9wRNfJPnSY=G6Gjib7MeEXM4D1A1YZsrVmbs1W6A@mail.gmail.com>
	<1355234914.2356.85.camel@falcor>
	<CA+55aFwA3isRny9JyqxzjoysHbRhiKpBheeEi6VZrnWokt521A@mail.gmail.com>
	<CALLzPKZQ3=qNOxJk-yqDGEzqkcKLoc9tPPD8o9QbJOUOB1nWuQ@mail.gmail.com>
	<CA+55aFxh2SH9WcXbb+hD3PtWa4ZTqYNUxvbqZh27vwANuUTE8w@mail.gmail.com>
Date: Tue, 11 Dec 2012 20:12:53 +0200
Message-ID: <CALLzPKakDLO-_ERScq_cAvAVLFU_5rRSyvoudjba=cFo96c-Mw@mail.gmail.com>
Subject: Re: [PATCH 0/2] ima: policy search speedup
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 7:55 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Dec 11, 2012 at 9:40 AM, Kasatkin, Dmitry
> <dmitry.kasatkin@intel.com> wrote:
>>>
>>> Quite frankly, this seems stupid.
>>
>> What exactly seems stupid here?
>
> What I said. Go back and read it. I gave three reasons. Why do you ask?
>
> I'll give one more reason, but you probably won't read *this* email
> either, will you?
>
>> There are different filesystems which are not checked by IMA/EVM,
>> such as pseudo-filesystems.
>
> Did you read my email?
>
> There are probably *also* individual that aren't checked by IMA/EVM
> even on filesystems that *do* check other files.
>
> No?
>
> And your "pseudo-filesystems" argument is pretty stupid too, since WE
> ALREADY HAVE A FLAG FOR THAT!
>
> Guess where it is? Oh, it's in the place I already mentioned makes
> more sense. Look for S_PRIVATE in inode->i_flags, and IS_PRIVATE() in
> users. It's what the other security models already use to avoid
> bothering calling down to the security layers. The fact that the
> integrity layer bypasses the normal security layer in
> ima_file_check(), for example, is no excuse to then make up totally
> new flags.

Actually S_PRIVATE does not work work for normal filesystems which IMA
might want to ignore.

>
> So let me repeat: adding a new superblock flag seems STUPID. Why is it
> in a completely different place than all the other flags that we
> already have for these kinds of things? Why should we add a new field,
> when we have existing fields that seem to do exactly this, do it
> better, and are already used?
>
> And don't ask me why without reading this email. OK?
>
>                  Linus
