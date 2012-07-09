Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab2GIWgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 18:36:18 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:45421 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752364Ab2GIWgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 18:36:16 -0400
Message-ID: <1341873376.6118.56.camel@joe2Laptop>
Subject: Re: +
 checkpatch-add-check-for-use-of-sizeof-without-parenthesis.patch added to
 -mm tree
From: Joe Perches <joe@perches.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
        apw@canonical.com
Date: Mon, 09 Jul 2012 15:36:16 -0700
In-Reply-To: <alpine.DEB.2.00.1207091514310.32082@chino.kir.corp.google.com>
References: <20120709215256.9A4F71E0043@wpzn4.hot.corp.google.com>
	 <alpine.DEB.2.00.1207091514310.32082@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-09 at 15:23 -0700, David Rientjes wrote:
> On Mon, 9 Jul 2012, akpm@linux-foundation.org wrote:
> 
> > From: Joe Perches <joe@perches.com>
> > Subject: checkpatch: Add acheck for use of sizeof without parenthesis
> > 
> > Kernel style uses parenthesis around sizeof.
> > 
> 
> Nack, there's a difference between "sizeof *task" and 
> "sizeof(struct task_struct)".  The former operates on a unary expression 
> and the latter operates on a type.  There are over 1000 occurrences in the 
> kernel where the sizeof operator, the former, is used on a unary 
> expression.

Huh?  Maybe I misunderstand you.

$ cat sizeof.c
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>

struct foo {
	int bar[20];
	char *baz;
};

int main(int argc, char **argv)
{
	struct foo bar;
	struct foo *baz;

	printf("1: %zu\n", sizeof(struct foo));
	printf("2: %zu\n", sizeof bar);
	printf("3: %zu\n", sizeof *baz); 

	return 0;
}

$ gcc sizeof.c
$ ./a.out
1: 84
2: 84
3: 84

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 



