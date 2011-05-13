Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759583Ab1EMX02 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 19:26:28 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57103 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758715Ab1EMX0Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 19:26:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SxYFFId0ELaSBUKb8gwd98P5Yy4RJ61IvpGv+FuyyvocwA4733IENYEr7OL/HR2zvr
         cVEE3W4CSpZfZtWILkjL48qNkVFymElNQdQ9u16lS8xzZzb/sm7Vi1Waqm3/+PKpL5cl
         F0DuClMJYZs+eHlgAQazeI3lETwaw1rhapW/8=
MIME-Version: 1.0
In-Reply-To: <4DCD8CE4.4090404@suse.cz>
References: <1d7d3b31c0da82ce8ce75778922155b7004a8f7e.1305224477.git.mfm@muteddisk.com>
	<4DCC4365.3030907@suse.cz>
	<BANLkTimKpJoUnoYx8gXi6KCYgVpnXno4ow@mail.gmail.com>
	<4DCC4F05.7010306@suse.cz>
	<BANLkTimrW=ZG2sGG1Q8QehSnh5rW1eBzGw@mail.gmail.com>
	<4DCCEB48.7030602@suse.cz>
	<BANLkTimcs83J3O8o7npLftBaQk1WKKZ=2Q@mail.gmail.com>
	<4DCD8CE4.4090404@suse.cz>
Date: Fri, 13 May 2011 16:26:23 -0700
Message-ID: <BANLkTinGrUb-U_7TLbMiqacC2mywAbxJVw@mail.gmail.com>
Subject: Re: [Resend PATCH] package: Makefile: fix perf target bug
From: matt mooney <mfmooney@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 12:56 PM, Michal Marek <mmarek@suse.cz> wrote:
> On 13.5.2011 20:52, matt mooney wrote:
>> So the real problem is that tools/perf/MANIFEST contains wildcards,
>> and when git archive is run, file name expansion isn't working
>> properly. By adding the $(srctree) as a prefix, globbing works but
>> then git archive requires --work-tree to be set.
>
> I see. So how about
> git --git-dir=$(srctree)/.git archive ... \
>    $$(cd $(srctree); echo $$(cat tools/perf/MANIFEST))
> ? That does exactly the same as before the patch, just changes to
> $(srctree) so that the expansion works.

Sure that works too! I guess it is less invasive than my original
change. I will fix that up and resend it.

-matt

-- 
GPG-Key: 9AFE00EA
