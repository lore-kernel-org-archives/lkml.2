Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761423Ab2J3ABM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 20:01:12 -0400
Received: from TYO201.gate.nec.co.jp ([210.143.35.51]:44540 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab2J3ABJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 20:01:09 -0400
Message-ID: <508F188D.2000408@ce.jp.nec.com>
Date: Tue, 30 Oct 2012 09:00:13 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: "Theodore Ts'o" <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>,
        "Luck\, Tony" <tony.luck@intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Kleen\, Andi" <andi.kleen@intel.com>,
        "Wu\, Fengguang" <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Akira Fujita <a-fujita@rs.jp.nec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 2/3] ext4: introduce ext4_error_remove_page
References: <1351177969-893-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1351177969-893-3-git-send-email-n-horiguchi@ah.jp.nec.com> <20121026061206.GA31139@thunk.org> <3908561D78D1C84285E8C5FCA982C28F19D5A13B@ORSMSX108.amr.corp.intel.com> <20121026184649.GA8614@thunk.org> <3908561D78D1C84285E8C5FCA982C28F19D5A388@ORSMSX108.amr.corp.intel.com> <20121027221626.GA9161@thunk.org> <20121029011632.GN29378@dastard> <20121029024024.GC9365@thunk.org> <m27gq9r2cu.fsf@firstfloor.org> <20121029182455.GA7098@thunk.org> <m21ughksh3.fsf@firstfloor.org>
In-Reply-To: <m21ughksh3.fsf@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/12 04:07, Andi Kleen wrote:
> Theodore Ts'o <tytso@mit.edu> writes:
>> Note that the problem that we're dealing with is buffered writes; so
>> it's quite possible that the process which wrote the file, thus
>> dirtying the page cache, has already exited; so there's no way we can
>> guarantee we can inform the process which wrote the file via a signal
>> or a error code return.
> 
> Is that any different from other IO errors? It doesn't need to 
> be better.

IMO, it is different in that next read from disk will likely succeed.
(and read corrupted data)
For IO errors come from disk failure, next read will likely fail
again so we don't have to remember it somewhere.

>> Also, if you're going to keep this state in memory, what happens if
>> the inode gets pushed out of memory? 
> 
> You lose the error, just like you do today with any other IO error.

-- 
Jun'ichi Nomura, NEC Corporation

