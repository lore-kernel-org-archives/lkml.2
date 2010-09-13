Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab0IMHQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 03:16:53 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:51597 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab0IMHQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 03:16:52 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Florian Mickler <florian@mickler.org>
Cc: Christoph Hellwig <hch@infradead.org>, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Stephen Hemminger \(role\:commit_signer\)" <shemminger@vyatta.com>,
        "Wolfram Sang \(role\:commit_signer\)" <w.sang@pengutronix.de>,
        linux-kernel@vger.kernel.org
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
	<1284111767.1783.35.camel@Joe-Laptop>
	<20100911001350.GA11478@infradead.org>
	<1284165074.1783.213.camel@Joe-Laptop>
	<20100911004550.GA30584@infradead.org>
	<20100911112855.6ee6e929@schatten.dmk.lab>
Date: Mon, 13 Sep 2010 00:16:30 -0700
In-Reply-To: <20100911112855.6ee6e929@schatten.dmk.lab> (Florian Mickler's
	message of "Sat, 11 Sep 2010 11:28:55 +0200")
Message-ID: <m1hbhucdv5.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: infradead.org]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Florian Mickler <florian@mickler.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] get_maintainer.pl: append reason for cc to the name by default
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Florian Mickler <florian@mickler.org> writes:

> On Fri, 10 Sep 2010 20:45:51 -0400
> Christoph Hellwig <hch@infradead.org> wrote:
>
>> On Fri, Sep 10, 2010 at 05:31:14PM -0700, Joe Perches wrote:
>> > If you don't like it, you could use a .get_maintainer.conf
>> > file entry until some consensus is reached later.
>> 
>> I don't use the pice of junk at all.  What really pisses me off is that
>> I get spamed by all by tons of utterly useless cleanups patches (and
>> some useful but not at all interesting to me patches) because some
>> idiot made the bloody script return my address just because I touched a
>> file.  If it goes on like that I'll simply have to add a mail filter to
>> throw away all patches sent directly to me instead of a mailinglist.
>> 
>
> But would you also have the same attitude towards these specific
> 'spams' if it were made clear in the email adress field that you were
> cc'd as a commit_signer  (vs maintainer)?
>
> I know it is a bit hackisch to have stuff in the name field, but it is
> rfc conform, it is even proposed for redirected email '(by way
> of...)'. 

It is trivial for a human to look at a git log and see which changes
were just global cleanups and which changes were actual maintenance.
Apparently get_maintainers doesn't have that ability.

Have seen some files with something like 5 years of changes without a
single commit by a maintainer and the only changes happening to it are
global cleanup changes.

If get_maintainers would look at MAINTAINERS and validate or invalidate
that information by looking at git that would be useful.

If get_maintainers can't validate what in MAINTAINERS perhaps it can
suggest that the author read the git log to get an idea of who has been
working on the code lately.

I guess what would be very good would be if get_maintainers would
present the information from the git log not as a fact but instead as a
guess.  Presenting people who only made a single change to a file on
equal footing with people were involved with 95% of the changes to a
file gets silly.

For people who have just a few commits in a file I expect presenting the
commit id's and subject lines of the patches they have touched so a
person with a brain can easily filter out the nonsense hits would be
very useful.

At this point I agree with Christoph being CC'd on every mips syscall
change on every architecture for the rest of my life because
get_maintainers.pl is too stupid to even indicate to the user of the
script that it might have made a mistake is silly.

Adding an "ignore me" tag to email addresses generated by
get_maintainer.pl would only encourage people to filter those emails
when they get them, which is not what we want.  Let's see if we can make
the script smart enough so people sending patches can use their own
intelligence to keep from asking people to look at things that they have
utterly no interest in.

This whole thing reminds me of a quote my father used to have hanging
in his study: "To err is human. To really foul things up use a computer"

Eric
