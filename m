Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab2CQFKo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 01:10:44 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:42628 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922Ab2CQFKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 01:10:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:date:message-id:mime-version:content-type; q=dns; s=
	sasl; b=WF75TCuuwrcwzYPZ0rflxsHWQQuKhyCXxnlfeqDxw2xfRFRYu3pWGBTB
	lxndZ2FIAsoNcZHohZSC1En6s+8JhQf2nzcx5KQqNeAEKxIQIW4G+0pHoV7IGviO
	yBvEaLfC1LjGjpy85SEG3j+A52xxFVJIysMRDafWvDWLRrPaNFA=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Please discuss: what "git push" should do when you do not say what
 to push?
Mail-Followup-To: git@vger.kernel.org
Date: Fri, 16 Mar 2012 22:10:39 -0700
Message-ID: <7v7gyjersg.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 8AC6CE66-6FEF-11E1-AA84-9DB42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a proposal to change the default behaviour of 'git push' on the
Git mailing list. The goal of this message is to encourage you to discuss
it before it happens (or the change is aborted, depending on the outcome
of the discussion).

In the current setting (i.e. push.default=matching), 'git push' without
argument will push all branches that exist locally and remotely with the
same name. This is usually appropriate when a developer pushes to his own
public repository, but may be confusing if not dangerous when using a
shared repository. The proposal is to change the default to 'upstream',
i.e. push only the current branch, and push it to the branch 'git pull'
would pull from. Another candidate is 'current'; this pushes only the
current branch to the remote branch of the same name.

For more details on the behavior of Git with these values, read the
documentation about 'push.default' in 'man git-config'
(http://schacon.github.com/git/git-config.html).

You may be negatively affected when such a change happens if you do not
see anything in the output from 'git config push.default' and if you rely
on the default that pushes all your matching branches. On the other hand,
you may want to see the default behaviour to change, especially if you are
using shared repositories. In either case, please join the discussion to
give us more data point and help us decide the future of Git. Also, if
you think your friends and colleagues will be affected by this change,
either positively or negatively, please tell them about this discussion.

What has been discussed so far can be seen in this thread:

    http://thread.gmane.org/gmane.comp.version-control.git/192547/focus=192694

Previous relevant discussions include:

    http://thread.gmane.org/gmane.comp.version-control.git/123350/focus=123541
    http://thread.gmane.org/gmane.comp.version-control.git/166743

To join the discussion, send your messages to:

    git@vger.kernel.org

The list accepts messages from non-subscribers, and you do not have to ask
"please Cc me, I am not subscribed", as it's customary to Cc: posters when
replying on this list.
