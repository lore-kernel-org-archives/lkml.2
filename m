Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab1INAjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 20:39:20 -0400
Received: from uk.vilain.net ([92.48.122.123]:43447 "EHLO uk.vilain.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409Ab1INAjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 20:39:19 -0400
X-Greylist: delayed 472 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Sep 2011 20:39:19 EDT
Message-ID: <4E6FF5D9.3080709@vilain.net>
Date: Tue, 13 Sep 2011 17:31:21 -0700
From: Sam Vilain <sam@vilain.net>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Junio C Hamano <gitster@pobox.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>, git@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Survey] Signed push
References: <7vaaa8xufi.fsf@alter.siamese.dyndns.org>
In-Reply-To: <7vaaa8xufi.fsf@alter.siamese.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/13/11 9:45 AM, Junio C Hamano wrote:
>   * You push out your work with "git push -s";
>
>   * "git push" prepares a "push certificate" (it is meant to certify "these
>     are the commits I place at the tips of these refs"), which is a human
>     and machine readable text file in core, that may look like this:
>
>          Push-Certificate-Version: 0
>          Pusher: Junio C Hamano<gitster@pobox.com>
>          Update: 3793ac56b4c4f9bf0bddc306a0cec21118683728 refs/heads/master
>          Update: 12850bec0c24b529c9a9df6a95ad4bdeea39373e refs/heads/next
>
>     and asks you to GPG sign it. You only unlock your GPG key and the
>     command internally runs GPG, just like "tag -s".
>
>   * When "git push" finishes, the receiving end has this record in its
>     refs/notes/signed-push notes tree, together with your previous pushes
>     (as this is not a shared repository, it will record only your pushes).
>     The notes annnotate the commits named on the "Update:" lines above.

If the push certificate also has the previous commit IDs for the changed 
refs, then you actually have an audit log.  Otherwise, it does not 
certify the commit range they pushed.

This is an important prerequisite for a fully distributed, peer to peer 
git.  For this case it would also need something to distinguish which 
repository is to be updated; such as a canonical repository URL (or list 
of URLs), or just a short project name.  A P2P protocol can then know 
projects as (KEYID, projectname).

Sam
