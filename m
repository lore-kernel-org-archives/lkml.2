Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760805Ab0KRXcI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 18:32:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52655 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754235Ab0KRXcF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 18:32:05 -0500
MIME-Version: 1.0
In-Reply-To: <1290121382-4039-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1290121382-4039-1-git-send-email-zohar@linux.vnet.ibm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 18 Nov 2010 15:31:10 -0800
Message-ID: <AANLkTin9sYf99fQ_w7Bp4N6Gsm3PR0akpCU=4YEkOaez@mail.gmail.com>
Subject: Re: [PATCH v1.2 0/5] IMA: making i_readcount a first class inode
 citizen (reposting)
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, jmorris@namei.org,
        akpm@linux-foundation.org, eparis@redhat.com, viro@zeniv.linux.org.uk,
        Dave Chinner <david@fromorbit.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        David Safford <safford@watson.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 3:02 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>
> This patchset separates the incrementing/decrementing of the i_readcount, in
> the VFS layer, from other IMA functionality, by replacing the current
> ima_counts_get() call with i_readcount_inc(). Its unclear whether this call to
> increment i_readcount should be made earlier, like i_writecount.  Currently the
> call is situated immediately after the switch from put_filp() to fput() for
> cleanup.

Well, it seems nicer than the situation we have now. So I'm certainly
ok with seeing this merged for 2.6.38 (through the security tree?) if
nobody has objections.

It's a bit sad to have another atomic in the open path, but if the
lease people want this and are ok with just the counter (no races?)
then it seems worth it.

                      Linus
