Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934824Ab2DLWDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 18:03:18 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55683 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934713Ab2DLWDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 18:03:15 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwa_wgBT85_Giy-23V5WpzRFrw9oCnFpTqVVam3DeG-7A@mail.gmail.com>
References: <20120411231102.GA6404@kroah.com> <CAJyhjX2KrfSJW64PJMTHou9zSojsfA1iNT-WahinfMBce_B=BA@mail.gmail.com>
 <20120412002927.GA23167@kroah.com> <CAMP44s3Jh-t07A+i82qbAMQyEN0oWTmKk5BJcst942gFdD0=VA@mail.gmail.com>
 <20120412011313.GA23764@kroah.com> <CAMP44s2q+bQE3-zsX4bs=sQDt4jf8eE5bwZ8V88UjodjRyAjog@mail.gmail.com>
 <20120412144626.GA14868@kroah.com> <CAMP44s1T4EVwpzDuV_vV0Zh-5WcPCwdw9eeOfL17Geqp_UFN-Q@mail.gmail.com>
 <CA+55aFwKYYgZcBX=L-q_6UdvkvFai+yjzgVxq7cA+HLL-Zojhw@mail.gmail.com>
 <CAMP44s14SQont1wyMeOuWcXUT3U5Tgnoj9mbbgOdVXY_hN0+-w@mail.gmail.com>
 <CA+55aFyLEJsz1yvu4bYe+RHdhLd-XXEScxtAgje=fyuUM+1XxA@mail.gmail.com> <CA+55aFwa_wgBT85_Giy-23V5WpzRFrw9oCnFpTqVVam3DeG-7A@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Thu, 12 Apr 2012 15:02:54 -0700
X-Google-Sender-Auth: NMOzh-nYp8wLqVePIYkdLLSHjno
Message-ID: <CAB=NE6XTF1e07n_rmx2ZP85xbAoeKb8binQWmdvw8MujFey2ug@mail.gmail.com>
Subject: Re: [ath9k-devel] [ 00/78] 3.3.2-stable review
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 2:44 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Apr 12, 2012 at 2:34 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> So just reverting it from stable, *WITHOUT LEARNING THE LESSON*, is
>> not a no-op at all, it's a sign of being a f*cking moron.
>
> Btw, the revert is now in my tree (commit 011afa1ed8c4), and marked
> for stable. So *now* Greg can revert it from stable too.
>
> But the important lesson to everybody should be that "we don't lose
> fixes from -stable". If a problem was found in stable, it needs to be
> fixed upstream. In fact, quite often people *do* find problems in
> stable, because it tends to have more users more quickly than
> mainline. That makes it really really important to make sure that
> those problems get fixed upstream, and not hidden in stable due to
> some kind of dieseased "it's a no-op to revert it" thinking.
>
> End of story.

FWIW if people want stable fixes propagated faster (before Linus sucks
it in or Greg sucks it in after Linus) things like compat-wireless (to
be renamed to compat-drivers) allows us to get these out, but we label
them properly [0]. We in fact have a place holder for even other type
of non-upstream patches that any PHB may come up with as required but
-- the key is to

1) help categorize these properly
2) keep metrics of them
3) prioritize upstream first

The pending-stable/ patches get patches out to the community faster
than Linus / Greg can apply them or before we even get the community
to test them. We get these sucked out by looking for the Cc:
stable@vger.kernel.org The linux-next-cherry-pick/ allows you suck out
non-stable patches and I gladly accept such patches so long as they
are in linux-next and I can suck them out automatically if you Cc:
stable@orbit-lab.org. There are similar tricks for the other types of
patches.

[0] http://wireless.kernel.org/en/users/Download/stable/#Additional_patches_to_stable_releases

  Luis
