Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab0EXOoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 10:44:12 -0400
Received: from smtp-out.google.com ([74.125.121.35]:46253 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab0EXOoL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 10:44:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=nBpSTCf6I6iTzNWRiegszPBwhwsN3+eDprehSAXFve+w0+ANuHmoMQ3yGzMiiu2IE
	eR8uCoWD0Jj9slVb0TP+Q==
MIME-Version: 1.0
In-Reply-To: <20100524115737.GY3991@agk-dp.fab.redhat.com>
References: <1274294304-30606-1-git-send-email-wad@chromium.org>
	<1274294304-30606-3-git-send-email-wad@chromium.org>
	<20100524115737.GY3991@agk-dp.fab.redhat.com>
Date: Mon, 24 May 2010 09:44:07 -0500
X-Google-Sender-Auth: w0xswuHx_zVD1Yf7P3yTJ5i7IuQ
Message-ID: <AANLkTik8F43_4SRkH7XpfX5CTQ-xQ_8f3_yJTjDqSulU@mail.gmail.com>
Subject: Re: [dm-devel] [PATCH v3 3/3] dm: lookup devices by path with 
	name_to_dev_t
From: Will Drewry <wad@chromium.org>
To: agk@redhat.com
Cc: linux-kernel@vger.kernel.org, snitzer@redhat.com, dm-devel@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 6:38 AM, Alasdair G Kergon <agk@redhat.com> wrote:
> I'll apply this, [snip]

Thanks!

On Mon, May 24, 2010 at 6:57 AM, Alasdair G Kergon <agk@redhat.com> wrote:
> On Wed, May 19, 2010 at 01:38:24PM -0500, Will Drewry wrote:
>> +     char base_path[32];  /* size from name_to_dev_t */
>
>> +     /* stage the shorter path for name_to_dev_t. */
>> +     strncpy(base_path, path, sizeof(base_path));
>
> I'm dropping that, and just passing path directly, so the strlen test
> will be used.  (There's a "name += 5" in there so 32 would ignore
> any longer standard names anyway.)

Sounds good.  And nice catch on the truncation with 32 - in an
attempt to minimize the extra copying, I went a bit too far!

fwiw, the only reason for the copy was because |path| is a
const in the function but not when passed to name_to_dev_t.
I wasn't sure what the preferred practice was so I just duped
the data needed.

cheers!
will
