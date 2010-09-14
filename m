Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab0INRTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 13:19:51 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:49002 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab0INRTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 13:19:49 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Florian Mickler <florian@mickler.org>
Cc: Joe Perches <joe@perches.com>, Christoph Hellwig <hch@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
	<1284111767.1783.35.camel@Joe-Laptop>
	<20100911001350.GA11478@infradead.org>
	<1284165074.1783.213.camel@Joe-Laptop>
	<20100911004550.GA30584@infradead.org>
	<20100911112855.6ee6e929@schatten.dmk.lab>
	<m1hbhucdv5.fsf@fess.ebiederm.org>
	<1284364665.22185.116.camel@Joe-Laptop>
	<20100913105434.62b150f7@schatten.dmk.lab>
Date: Tue, 14 Sep 2010 10:19:33 -0700
In-Reply-To: <20100913105434.62b150f7@schatten.dmk.lab> (Florian Mickler's
	message of "Mon, 13 Sep 2010 10:54:34 +0200")
Message-ID: <m1lj749ra2.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Florian Mickler <florian@mickler.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] get_maintainer.pl: append reason for cc to the name by default
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Florian Mickler <florian@mickler.org> writes:

> On Mon, 13 Sep 2010 00:57:45 -0700
> Joe Perches <joe@perches.com> wrote:
>
>> On Mon, 2010-09-13 at 00:16 -0700, Eric W. Biederman wrote:
>> > It is trivial for a human to look at a git log and see which changes
>> > were just global cleanups and which changes were actual maintenance.
>> > Apparently get_maintainers doesn't have that ability.
>> 
>> Do you have a useful, trivial or non-trivial algorithm
>> to suggest or is that soft commenting?  All I'll say is
>> AI can be a surprisingly difficult field.
>
> :) indeed. 

Which is why the tool needs to assist a person in doing the work.
Please deliver a tool and not a broken solution.

>> > Have seen some files with something like 5 years of changes without a
>> > single commit by a maintainer and the only changes happening to it are
>> > global cleanup changes.
>> 
>> Then likely there's no actual maintainer for that file.
>
> and which means that get_maintainer.pl --git will output either nothing
> (if we somehow get its heuristics to filter correctly) or wrong people. 
>
>> 
>> > If get_maintainers would look at MAINTAINERS and validate or invalidate
>> > that information by looking at git that would be useful.
>> 
>> Some entries in MAINTAINERS are outdated.
>> Validating MAINTAINERS entries is probably best done once.
>> 
>> I suggest you try that concept out, see what you get, and
>> make public the results.
>
> It is easy to make get_maintainer.pl output less people. 
> What is not easy is to get it to decrease false-positives while
> not decreasing it's detection rate. 

What is needed is something other than output that is a list of
email addresses.

email address foo had x% of non-author signed off bys
email address foo had y% of author signed off bys
email address foo had y% of author commits.
email address foo came from the Maintainers file.

Additionally for email addresses that hit less often a list
of patch subject titles, and truncated sha1 patch ids.  So
with luck you can tell at a glance the person is of interest
and if not you can look at their commits quickly and see.

That is all pretty trivial, it should be fast and it should with
a little care let the bogus results be filtered out quickly.

> As far as I can see, Andrew is in favor of not caring about
> false-positives in order to not sacrifice the detection rate of the
> tool. 

Which means in time every long time developer will be copied on every
patch.  That is what we have lkml for.  I don't have a problem with the
tool returning false positives.  I do have a problem with the tool
taking away the ability and the responsibility of developers to pay
attention to which human beings they are sending their patches to.

I don't want the tool to do the filtering.  I want the tool to give
enough information that the person using the tool can get a feel for the
development history of the affected files and suggestions with a couple
of metrics how useful someone is when Cc'd on a commit.

> My approach tried to lower the impact of false positives by allowing
> people to filter between "cc'd as maintainer" and "cc'd as
> commit_signer".  The former is pretty much never a false positive (as
> long as MAINTAINERS is up to date) while the latter is more of a
> hit'n'miss kind of method. 

And right now get_maintainer.pl is decreasing the relevancy of cc lines
in commits, which if get_maintainers.pl is used enough could be a
vicious circle.

The problem as I see it is you present of a list of email addresses
without enough information for someone using the tool to guess how
accurate the results are.

Eric

