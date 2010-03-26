Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab0CZFnG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 01:43:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35890 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752Ab0CZFnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 01:43:03 -0400
Message-ID: <4BAC4961.4060302@suse.de>
Date: Fri, 26 Mar 2010 14:42:57 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] sysfs: simplify handling for s_active refcount
References: <20100324031829.2136.66489.stgit@notabene.brown>	<20100324032008.2136.52640.stgit@notabene.brown>	<m139znogl0.fsf@fess.ebiederm.org> <20100326163236.1ffb2c2b@notabene.brown>
In-Reply-To: <20100326163236.1ffb2c2b@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Neil.

On 03/26/2010 02:32 PM, Neil Brown wrote:
> Hopefully if there are really problems (maybe I've fundamentally
> misunderstood caches) they can be easily resolved (a couple of memory
> barriers at worst?).

Oh, no, please don't do that.  That will inject a whole lot more of
complexity into the mix.  Now, it's only a problem of logical
complexity.  If you add memory barriers there, it not only complicates
the problem itself beyond recognition but also reduces problem
reproducibility (especially because x86/64 are relatively strongly
ordered) and thus test coverage significantly.  Now the refcounting
can be understood by most people who put some time into it but if you
put memory barriers into it, only Oleg would be able to identify
problems.  :-P

If you really want to kill the bias and in an easy readable way,
please put it inside a struct w/ dedicated spinlock but if you are
gonna do that it might as well be better to simply implement the bias
anti-pattern correctly there once.

Thanks.

-- 
tejun
