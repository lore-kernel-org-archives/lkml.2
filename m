Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab2IYGBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 02:01:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46643 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab2IYGB2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 02:01:28 -0400
From: Dave Yost <Dave@Yost.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: RFE: tty color features
Message-Id: <D1425869-534B-4AD9-BF2E-956A76E29894@Yost.com>
Date: Mon, 24 Sep 2012 23:01:21 -0700
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 6.1 \(1498\))
X-Mailer: Apple Mail (2.1498)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(This is not a complete spec, only a sketch.)

It would be nice to be able to specify fg/bg colors at the tty level, so that echoed characters can be colorized. Then your shell can arrange that shell command input is one fg/bg color, and other input taken by commands run from the shell is another color.

For example, like this:
 
  stty color-echo=#ffdddd/#000022 color-out=#ddffdd color-err=/#220000
  stty color-fd3=/#222255
  stty color-out=

or

  stty color-type=cmd:#ffdddd/#000000
  stty color-echo=cmd
  echo foo
  stty color-echo=#eeeeee
  echo bar
  stty color-echo=cmd
  echo baz

Names of things that can be colorized might include:
  echo
  out
  err
  fd0
  fd1
  fd2
  ...

I think named colors should be supported, with at least these builtin names:
  echo-default
  in-default
  out-default
This
  stty color-type=echo-default:
tells the tty driver that echo-default does no colorizing.

I used #xxxxxx notation as a placeholder. Probably in actual use, the user would supply a terminal escape sequence.

Typeahead is tricky:

  stty color-typeahead=#ff6666/004444

This would cause typeahead to be echoed in the desired color, and then when appropriate, typeahead characters could change color, such as when they are consumed or when they are hanging there with a pending cooked read.