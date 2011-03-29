Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab1C2QFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 12:05:31 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58207 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab1C2QFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 12:05:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=V44rHzCDNhTV3Ix5mKaTi/UkNLbgTQfatrRd6RhW7UxK+y89FW/qdfMvpC5zC47MJ6
         8cr+5RlldswK7xA10Kfjcu4Ws34PbdEg86K2iCW5ce1gX2IpA3UQqQLrsLuAU3YBZxVW
         KOPVTvHq+fSFyqcLwotS0ecYrqVcp7EdrDZ4w=
MIME-Version: 1.0
In-Reply-To: <4D8FB93A.6020508@linux.vnet.ibm.com>
References: <1301052651-21440-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1301052651-21440-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<4D8D0704.7080106@linux.vnet.ibm.com>
	<877hbl0xxq.fsf@linux.vnet.ibm.com>
	<4D8FB93A.6020508@linux.vnet.ibm.com>
Date: Tue, 29 Mar 2011 11:05:08 -0500
Message-ID: <AANLkTik1nw839sfza143jRgc3_w6dDtrxUC+_w7O3Okn@mail.gmail.com>
Subject: Re: [V9fs-developer] [PATCH 3/5] 9p: revert tsyncfs related changes
From: Eric Van Hensbergen <ericvh@gmail.com>
To: Venkateswararao Jujjuri <jvrao@linux.vnet.ibm.com>
Cc: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 27, 2011 at 5:24 PM, Venkateswararao Jujjuri
<jvrao@linux.vnet.ibm.com> wrote:
>
> Nice explanation. I looked at NFS and realized that they also follow
> write_inode approach.
> So I think you should make it explict that this will be helpful to dotl
> also and may and TFSYNCFS
> in the future if needed. With that I ack this.
>

If this is something we really think we'll be adding back in the
future, is there someway we can conditionalize its use (default off
perhaps) so that if a particular server wanted to take advantage of
it, they could.  This would seem preferable to just backing out the
whole patch.

Another aspect which I didn't consider when we added it is what it
would do to older versions of the servers which didn't have TFSYNCFS
-- maybe this is a good case study for the .L graceful degredation
plan we had talked about in the past where you try a tfsyncfs and if
the server returns an error that it doesn't implement it you back off
to another solution.

Thoughts?  Sorry if I'm being dense -- still adjusting to new sleep
schedule with new baby and spent 16 hours yesterday cranking out two
publication submissions, so folks will have to bear with me for a bit.

        -eric
