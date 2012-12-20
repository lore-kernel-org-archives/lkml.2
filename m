Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab2LTXux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 18:50:53 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:36980 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab2LTXuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 18:50:46 -0500
MIME-Version: 1.0
In-Reply-To: <20121220233624.GX15182@dastard>
References: <CALCETrXs15M-cJRGD_R7fXBxOXR=Pyqsh2dVC78DgShxwn60nA@mail.gmail.com>
 <20121218015705.GH4939@ZenIV.linux.org.uk> <CALCETrUHF40CJYi1=aWpqhW9qkxUDQNt9LAAGoWA57YXowdr_w@mail.gmail.com>
 <20121218213043.GF15182@dastard> <CALCETrV9fEfTVbiSzai2dvk6MWwDhsD_nAKs7Z1JP0ZkF-eruw@mail.gmail.com>
 <20121220070323.GU15182@dastard> <CALCETrUxFHHVPO=EC0jmV9SSKJiOm-mc-xwsd6Ruk3p5nC4fFQ@mail.gmail.com>
 <20121220233624.GX15182@dastard>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 20 Dec 2012 15:42:24 -0800
Message-ID: <CALCETrXMPyRC_JNnU_UExqPTMU=Wf+m0tn9fN+dgxKEd5+OO7Q@mail.gmail.com>
Subject: Re: Are there u32 atomic bitops? (or dealing w/ i_flags)
To: Dave Chinner <david@fromorbit.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 3:36 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Dec 20, 2012 at 12:05:09PM -0800, Andy Lutomirski wrote:
>> On Wed, Dec 19, 2012 at 11:03 PM, Dave Chinner <david@fromorbit.com> wrote:
>> start_this_handle jbd2__journal_start jbd2_journal_start
>> ext4_journal_start_sb ext4_dirty_inode __mark_inode_dirty update_time
>> file_update_time ext4_page_mkwrite do_wp_page handle_pte_fault
>> handle_mm_fault
>
> Yup, as I suspected. It's a filesystem specific problem.
>
>> This is a showstopper for my software -- I'm running on a kernel with
>> the call to file_update_time commented out.
>
> Which means you are effectively running with O_CMTIME on all mmapped
> files....

Indeed.  I'm not thrilled by not having timestamps update, and IMO
adding O_CMTIME as part of the API seems like a silly way to "fix"
this.  I'd rather fix the implementation.

The problems may be fs-specific in the sense that an fs could fix them
internally, but I think something like my AS_CMTIME approach could fix
it everywhere with much less complexity.  Any thoughts on my patch
set?  (Are you the right person to review it?)

--Andy
