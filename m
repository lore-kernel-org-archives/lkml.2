Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476Ab1EKP6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:58:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756416Ab1EKP6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:58:01 -0400
Message-ID: <4DCA4C05.4030803@redhat.com>
Date: Wed, 11 May 2011 10:42:45 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110402 Thunderbird/3.1.7
MIME-Version: 1.0
To: Alasdair G Kergon <agk@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Wilcox <matthew@wil.cx>, Zdenek Kabelac <zkabelac@redhat.com>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        Hugh Dickins <hughd@google.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] Don't mlock guardpage if the stack is growing up
References: <alpine.DEB.2.00.1105082045250.15552@artax.karlin.mff.cuni.cz> <BANLkTikEpaRZK3X4YReeQAwgcv3HAGUwSw@mail.gmail.com> <alpine.DEB.2.00.1105091246550.32299@artax.karlin.mff.cuni.cz> <4DC7D37F.9040308@redhat.com> <20110509224511.GC15227@parisc-linux.org> <BANLkTikz-sGiy2NdzQMPzCWF64cVF-DZ7w@mail.gmail.com> <20110510225659.GE9253@agk-dp.fab.redhat.com>
In-Reply-To: <20110510225659.GE9253@agk-dp.fab.redhat.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2011 12:57 AM, Alasdair G Kergon wrote:
> (What other software packages make use of mlockall() and under what
> circumstances?)

Another one is cryptsetup for commands which manipulate with keys
in memory.
(Users of libcryptetup library are not forced to lock memory, it is optional
call. But cryptsetup itself as libcryptsetup library user always locks memory.)

And I am not happy with mlockall() as well but the lvm2 workaround
is quite complicated.

Basically it wants to lock memory with explicitly allocated keys
(this can be rewritten to use specific locked page though) but it
also need to lock various libdevmapper buffers when issuing dmcrypt
cfg ioctl (mapping table and messages contains key). So that's why
mlockall(MCL_CURRENT|MCL_FUTURE) was the simplest way (and no problems
reported yet).
(No that it is perfect but better than nothing... Of course
more important is to wipe memory with keys after use.)

Milan
