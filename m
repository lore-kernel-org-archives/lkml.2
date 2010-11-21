Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab0KUVd7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 16:33:59 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:53887 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657Ab0KUVdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 16:33:55 -0500
Subject: Re: [PATCH v1.2 0/5] IMA: making i_readcount a first class inode
 citizen (reposting)
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jmorris@namei.org, akpm@linux-foundation.org, eparis@redhat.com,
        viro@zeniv.linux.org.uk, Dave Chinner <david@fromorbit.com>,
        David Safford <safford@watson.ibm.com>
In-Reply-To: <AANLkTikjz3j4j-zLSzagF=wnVE1ROZBGsjtuhGEvB9=n@mail.gmail.com>
References: <1290121382-4039-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <AANLkTin9sYf99fQ_w7Bp4N6Gsm3PR0akpCU=4YEkOaez@mail.gmail.com>
	 <20101119175053.GC29148@fieldses.org>
	 <1290345498.2412.38.camel@localhost.localdomain>
	 <AANLkTikjz3j4j-zLSzagF=wnVE1ROZBGsjtuhGEvB9=n@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 21 Nov 2010 16:33:49 -0500
Message-ID: <1290375229.2412.95.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-21 at 09:56 -0800, Linus Torvalds wrote:
> On Sun, Nov 21, 2010 at 5:18 AM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> >
> > IMA (and the proposed EVM/IMA-appraisal patches) detects file change
> > based on i_version. When the file is closed, if the file has changed,
> > IMA marks the file as needing to be re-measured. Of course this requires
> > the filesystem to be mounted with iversion. Don't know if this helps.
> 
> If you only do this at close time, I see a _major_ security hole.
> 
> The attacker can just write to the file, and keep it open. Ta-daa,
> everybody who reads it sees the new contents, but your IMA logic is
> oblivious and thinks it doesn't need to be re-measured.
> 
>                             Linus

Not exactly.  While the file remains open for write, it doesn't make any
sense to re-measure the file, as there is nothing preventing the file
from continuing to change.  Any measurement would thus be meaningless.
Only after the file closes, does it make sense to re-measure.  I did not
mean to imply there isn't any indication of the problem in the
measurement list, there obviously is.

Mimi

