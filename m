Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab0GLQTv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 12:19:51 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:58437 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751780Ab0GLQTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 12:19:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=STun/qdzrmvvVFtl7uCM97mcKK+l/11EreR69GU8DmA9CQFrW+6g7mYx9JZkl3Lg4EKBef46veddujfNhVKNzbJgutipx3Qmw2yBxdrN6r6iGEykAgs91INVyIAk7sG1;
Date: Mon, 12 Jul 2010 09:20:03 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "Tino Keitel" <tino.keitel+xorg@tikei.de>
Subject: Re: [Bug #16207] Suspend and VT switch hangs since 2.6.34
Message-ID: <20100712092003.074ab8ee@virtuousgeek.org>
In-Reply-To: <Hc02ROPrUsG.A.zdH.cq7NMB@chimera>
References: <xkNyyYrLiTN.A.s_G.7p7NMB@chimera>
	<Hc02ROPrUsG.A.zdH.cq7NMB@chimera>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Jul 2010 02:33:28 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.33 and 2.6.34.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.33 and 2.6.34.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16207
> Subject		: Suspend and VT switch hangs since 2.6.34
> Submitter	: Tino Keitel <tino.keitel+xorg@tikei.de>
> Date		: 2010-06-09 17:53 (31 days old)
> Message-ID	: <20100609175356.GA17332@x61.home>
> References	: http://marc.info/?l=linux-kernel&m=127610606214060&w=2

Two commits in the X server repo (1.8 branch commits shown) might help
here:

commit	665aa7ce8645b50b888db32ebab4e192dbe00649
  OS support: fix writeable client vs IgnoreClient behavior

commit	090d26723f7cdbb3aebfe212170b7f81c163dd7b
  dixstruct: make ignoreCount change more ABI friendly

2.6.34 introduced some new features, and X will test for them and use
them if available.  However, the server's handling of clients was buggy
with the new code, which could cause clients to hang after VT switch,
waiting to be woken up.

-- 
Jesse Barnes, Intel Open Source Technology Center
