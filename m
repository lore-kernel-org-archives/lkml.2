Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab0KUR5M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 12:57:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50616 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754941Ab0KUR5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 12:57:10 -0500
MIME-Version: 1.0
In-Reply-To: <1290345498.2412.38.camel@localhost.localdomain>
References: <1290121382-4039-1-git-send-email-zohar@linux.vnet.ibm.com>
 <AANLkTin9sYf99fQ_w7Bp4N6Gsm3PR0akpCU=4YEkOaez@mail.gmail.com>
 <20101119175053.GC29148@fieldses.org> <1290345498.2412.38.camel@localhost.localdomain>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 21 Nov 2010 09:56:17 -0800
Message-ID: <AANLkTikjz3j4j-zLSzagF=wnVE1ROZBGsjtuhGEvB9=n@mail.gmail.com>
Subject: Re: [PATCH v1.2 0/5] IMA: making i_readcount a first class inode
 citizen (reposting)
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jmorris@namei.org, akpm@linux-foundation.org, eparis@redhat.com,
        viro@zeniv.linux.org.uk, Dave Chinner <david@fromorbit.com>,
        David Safford <safford@watson.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 21, 2010 at 5:18 AM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>
> IMA (and the proposed EVM/IMA-appraisal patches) detects file change
> based on i_version. When the file is closed, if the file has changed,
> IMA marks the file as needing to be re-measured. Of course this requires
> the filesystem to be mounted with iversion. Don't know if this helps.

If you only do this at close time, I see a _major_ security hole.

The attacker can just write to the file, and keep it open. Ta-daa,
everybody who reads it sees the new contents, but your IMA logic is
oblivious and thinks it doesn't need to be re-measured.

                            Linus
