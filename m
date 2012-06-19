Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab2FSFo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 01:44:57 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:58144 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab2FSFo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 01:44:56 -0400
X-AuditID: 9c930197-b7b87ae000000e4d-0b-4fe011d5d601
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, namhyung.kim@lge.com,
        mingo@kernel.org, peterz@infradead.org
Subject: Re: [RFC PATCH 0/2] libtraceevent/perf: Add support for trace-cmd plugins
References: <1339695333-64591-1-git-send-email-dsahern@gmail.com>
	<87lijlhv9v.fsf@sejong.aot.lge.com> <4FDF3D5C.1030209@gmail.com>
	<87d34wi0y3.fsf@sejong.aot.lge.com>
	<1340067793.25903.158.camel@gandalf.stny.rr.com>
	<878vfkhzr8.fsf@sejong.aot.lge.com>
	<1340069162.25903.176.camel@gandalf.stny.rr.com>
	<874nq8hyfa.fsf@sejong.aot.lge.com>
	<1340072171.25903.181.camel@gandalf.stny.rr.com>
Date: Tue, 19 Jun 2012 14:41:31 +0900
In-Reply-To: <1340072171.25903.181.camel@gandalf.stny.rr.com> (Steven
	Rostedt's message of "Mon, 18 Jun 2012 22:16:11 -0400")
Message-ID: <87vcinhn90.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2012 22:16:11 -0400, Steven Rostedt wrote:
> We can be a bit better at the raw print, sure. Here's the format that's
> there:
>
> 	field:__u64 rip;	offset:16;	size:8;	signed:0;
> 	field:__u32 csbase;	offset:24;	size:4;	signed:0;
> 	field:__u8 len;	offset:28;	size:1;	signed:0;
> 	field:__u8 insn[15];	offset:29;	size:15;	signed:0;
> 	field:__u8 flags;	offset:44;	size:1;	signed:0;
> 	field:__u8 failed;	offset:45;	size:1;	signed:0;
>
> It treated __u* as decimal numbers, but it also saw that insn[15] was an
> array, and with single bytes at that. So it thought it was a string, and
> tried to print it out as such.
>
> We can change the heuristics of this to make it more readable.
>

Right. The current heuristic treats an u8 array as a string:

static int field_is_string(struct format_field *field)
{
	if ((field->flags & FIELD_IS_ARRAY) &&
	    (strstr(field->type, "char") || strstr(field->type, "u8") ||
	     strstr(field->type, "s8")))
		return 1;

	return 0;
}

Do you want to get rid of u8 from the function? Or is there a
better way?

Thanks,
Namhyung
