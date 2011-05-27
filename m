Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab1E0TIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 15:08:42 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41642 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab1E0TIi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 15:08:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=WlKSnBWlirHCI66ocRkgjBqA9EwLrlY0+wrwf9gfJLMfQn1g7lP1j/H1aLUWPZjlJ2
         Mn50lrjT4TqjybyIQWu5HFrp6Kook+bNuV0bNCwh2abpw1SCsLsAW6Hx90ZmEaciMJt0
         RAbjcIMStTEXVxsVqKosgMRzYcLT7t9Ajvy60=
MIME-Version: 1.0
In-Reply-To: <20110527095336.25007886@endymion.delvare>
References: <20110527133003.8299b429.sfr@canb.auug.org.au>
	<20110527095336.25007886@endymion.delvare>
Date: Fri, 27 May 2011 12:08:37 -0700
X-Google-Sender-Auth: pISrQNky1un-15Sq27t7gdx1Edo
Message-ID: <BANLkTikAShzPv_6c6Z8Z9Xdt9TgQbcM-xA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the async_tx tree with Linus' tree
From: Dan Williams <dan.j.williams@intel.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Havard Skinnemoen <hskinnemoen@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Viresh Kumar <viresh.kumar@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 12:53 AM, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Stephen, Dan,
>
> On Fri, 27 May 2011 13:30:03 +1000, Stephen Rothwell wrote:
>> Today's linux-next merge of the async_tx tree got a conflict in
>> drivers/dma/dw_dmac.c between commit e05503ef1186 ("Haavard Skinnemoen
>> has left Atmel") from Linus' tree and commit aecb7b64dd9e
>> ("dmaengine/dw_dmac: Update maintainer-ship") from the async_tx tree.
>>
>> Just context changes.  I fixed it up (see below) and can carry the fix as
>> necessary.
>
> Dan's patch is just plain wrong. MODULE_AUTHOR is about who wrote the
> code, not who maintains it. A change of maintainer should lead to an
> update or addition to file MAINTAINERS.

The patch in question did also update MAINTAINERS.  Since Viresh has
done a good amount of work on the driver (top-developer by commits
since the initial merge) and likely cares about user reports (now that
he has stepped up to maintain it) is there a reason that he should not
have his own MODULE_AUTHOR line in the driver as well?

The real problem here is the late detection of the merge conflict.  We
need to submit Vinod's git tree for inclusion in -next.  Given the
relative patch traffic I think async_tx.git should come after
slave-dma.git in the merge order, and any reworks I do of the
non-slave case will be based on Vinod's baseline.  We'll get this in
shape for the next cycle as I had to rebase things a bit when pulling
the current slave-dma.git tree.

> Thanks Viresh for stepping in, BTW, new maintainers are always welcome.
>
> (As a side note, the relevance of MODULE_AUTHOR given the development
> and maintenance model the Linux kernel has embraced can certainly be
> discussed, but that's a different story.)

We don't seem to have documentation around it, but making a bunch of
commits and stepping up to be a maintainer seems enough justification
to have your contact info show up in modinfo...

--
Dan
