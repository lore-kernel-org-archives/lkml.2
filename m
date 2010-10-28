Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760504Ab0J1Rmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 13:42:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736Ab0J1Rmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 13:42:39 -0400
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Perf can't deal with many tracepoints
References: <E1PBFIJ-0004eC-Tj@tytso-glaptop>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Thu, 28 Oct 2010 13:42:36 -0400
In-Reply-To: <E1PBFIJ-0004eC-Tj@tytso-glaptop> (Theodore Ts'o's message of "Wed, 27 Oct 2010 19:20:35 -0400")
Message-ID: <y0mtyk6i583.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


"Theodore Ts'o" <tytso@mit.edu> writes:

> Perf will drop dead if it comes across tracepoints that have anything
> but primitive structure accessors in the TP_printk() section of the
> tracepoint definition.  For example, the ext4 and jbd2 tracepoints uses
> jbd2_dev_to_name() to translate a dev_t to a string.  

In the mean time, you may enjoy:

# stap -L 'kernel.trace("*")'
# stap -g -e '
%{
#include<linux/jbd2.h> 
%}
function jbd2name(dev) %{
   strlcpy(THIS->__retvalue, jbd2_dev_to_name(THIS->dev), MAXSTRINGLEN);
%}
probe kernel.trace("ext4_free_inode") {
   log(jbd2name($inode->i_sb->s_dev)) 
}'


> The block I/O tracepoints uses MAJOR() and MINOR() to translate a
> dev_t to a major/minor number pair.  [...]

(Similarly for this case.)


- FChE
