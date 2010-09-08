Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab0IHTzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 15:55:48 -0400
Received: from msux-gh1-uea01.nsa.gov ([63.239.65.39]:40405 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab0IHTzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 15:55:40 -0400
Subject: Re: [PATCH 0/5] hybrid union filesystem prototype
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jan Engelhardt <jengelh@medozas.de>, neilb@suse.de,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        vaurora@redhat.com, viro@zeniv.linux.org.uk, jblunck@suse.de,
        hch@infradead.org
In-Reply-To: <E1OrAm5-0002eF-Hw@pomaz-ex.szeredi.hu>
References: <20100826183340.027591901@szeredi.hu>
	 <20100827170551.19616048@notabene> <E1Ooub5-0007Wh-SQ@pomaz-ex.szeredi.hu>
	 <20100827213502.31af4a4c@notabene> <E1Op2BV-0008Ut-BR@pomaz-ex.szeredi.hu>
	 <20100829144207.4fbf2713@notabene> <E1Oq1RL-0003zF-Tw@pomaz-ex.szeredi.hu>
	 <alpine.LNX.2.01.1009021513040.10859@obet.zrqbmnf.qr>
	 <20100902233200.586fcb31@notabene>
	 <alpine.LNX.2.01.1009021625050.14798@obet.zrqbmnf.qr>
	 <E1OrAm5-0002eF-Hw@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Date: Wed, 08 Sep 2010 15:47:59 -0400
Message-Id: <1283975279.24418.54.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-02 at 16:28 +0200, Miklos Szeredi wrote:
> On Thu, 2 Sep 2010, Jan Engelhardt wrote:
> > There ought to be a reason that other implementations offer
> > doing multiple branches with a single vfsmount.
> 
> Overdesign.
> 
> Thanks,
> Miklos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Actually it's not overdesign. We support an arbitrary number of branches
with only the requirement that the top most branch be writable unless
you want the entire mount to be read-only. That is a feature that people
seem to have wanted for the many years that we have been working on
UnionFS. You have the limitation that you only support two branches
which is why you have to use the hack of making unions of unions of
unions where we would just add the 3 branches and mark them ro instead.
This kind of functionality makes administration more straight forward
when you are performing a task such as creating an RPM repository from a
series of loop back mounted images. I also used UnionFS to create a
mechanism for providing unified home directories on polyinstantiated MLS
systems (which is essentially a unified namespace with extra namespace
manipulation rules). I'd actually look at what UnionFS and AUFS have
done before you write their decisions off with snippy one word answers.

Dave

