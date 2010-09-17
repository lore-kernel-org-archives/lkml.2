Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab0IQOwH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 10:52:07 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49443 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab0IQOwG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 10:52:06 -0400
MIME-Version: 1.0
In-Reply-To: <20100917152639.0e88341a@basil.nowhere.org>
References: <1284663599-3549-1-git-send-email-wad@chromium.org>
	<20100917152639.0e88341a@basil.nowhere.org>
Date: Fri, 17 Sep 2010 09:52:03 -0500
Message-ID: <AANLkTinRNrmK_dm-3NEs9WpXOrZdG81QWHeJcU9XH3ot@mail.gmail.com>
Subject: Re: [PATCH][RFC] fs/exec.c: provide the correct process pid to the
 pipe helper
From: Will Drewry <wad@chromium.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Roland McGrath <roland@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        containers@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org,
        Eugene Teo <eugene@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 8:26 AM, Andi Kleen <andi@firstfloor.org> wrote:
> On Thu, 16 Sep 2010 13:59:59 -0500
> Will Drewry <wad@chromium.org> wrote:
>
>> format_corename uses task_tgid_vnr to provide the numeric pid of a
>> core-dumping process.  For file-based coredumps, this is perfectly
>> satisfactory.  However, when the core_pattern contains a pipe, the
>> substituted PID is invalid in the namespace of the core_pattern pipe
>> helper, the init namespace.
>
> Nasty problem. I wonder how many more similar problems name spaces
> have introduced.
>
> But wouldn't it be better to place the helper into the name space(s)
> of the executed process? I guess it would risk breaking some existing
> set ups, but it seem like the cleanest solution to me. If you want
> to move the core dump out of the name space you could still
> use a named pipe or something like that with someone outside listening.
>
> That would also fix the net namespace problem you mentioned

I agree.  This was what I did first, but I wasn't confident I'd done
it right.  I'll go ahead and post the two patches I used to accomplish
it.   I'm happy to spend some time polishing them until they are
functionally correct, if everyone is happy enough with the approach.

more to come,
will
