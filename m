Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab1IMSMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 14:12:06 -0400
Received: from mx2.parallels.com ([64.131.90.16]:35957 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755870Ab1IMSME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 14:12:04 -0400
Message-ID: <4E6F9CC4.2000601@parallels.com>
Date: Tue, 13 Sep 2011 15:11:16 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Paul Menage <paul@paulmenage.org>
CC: Greg Thelen <gthelen@google.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <containers@lists.osdl.org>,
        <netdev@vger.kernel.org>, <xemul@parallels.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Suleiman Souhlal <suleiman@google.com>,
        Lennart Poettering <lennart@poettering.net>
Subject: Re: [PATCH] per-cgroup tcp buffer limitation
References: <1315276556-10970-1-git-send-email-glommer@parallels.com> <CAHH2K0aJxjinSu0Ek6jzsZ5dBmm5mEU-typuwYWYWEudF2F3Qg@mail.gmail.com> <4E664766.40200@parallels.com> <CAHH2K0YJA7vZZ3QNAf63TZOnWhsRUwfuZYfntBL4muZ0G_Vt2w@mail.gmail.com> <4E66A0A9.3060403@parallels.com> <CAHH2K0aq4s1_H-yY0kA3LhM00CCNNbJZyvyBoDD6rHC+qo_gNg@mail.gmail.com> <4E68484A.4000201@parallels.com> <CAHH2K0YcXMUfd1Zr=f5a4=X9cPPp8NZiuichFXaOo=kVp5rRJA@mail.gmail.com> <4E699341.9010606@parallels.com> <CALdu-PCrYPZx38o44ZyFrbQ6H39-vNPKey_Tpm4HRUNHNFMpyA@mail.gmail.com> <4E6E39DD.2040102@parallels.com> <CALdu-PC7ESSUHuF4vfVoRFFfkaBt1V28rGW3-O5pT3WtegAh4g@mail.gmail.com>
In-Reply-To: <CALdu-PC7ESSUHuF4vfVoRFFfkaBt1V28rGW3-O5pT3WtegAh4g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [187.106.51.14]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2011 03:09 PM, Paul Menage wrote:
> Each set of counters (user, kernel, total) will have its own locks,
> contention and other overheads to keep up to date. If userspace
> doesn't care about one or two of the three, then that's mostly wasted.
>
> Now it might be that the accounting of all three can be done with
> little more overhead than that required to update just a split view or
> just a unified view, in which case there's much less argument against
> simplifying and tracking/charging/limiting all three.
What if they are all updated under the same lock ?
The lock argument is very well valid for accounting vs not accounting 
kernel memory. But once it is accounted, which counter we account to, I 
think, is less of a problem.
