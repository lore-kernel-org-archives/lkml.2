Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745Ab0DFFOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 01:14:05 -0400
Received: from mail-pz0-f193.google.com ([209.85.222.193]:36213 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab0DFFN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 01:13:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=U4hskblsCGhYq02hej5AYYetJXg7nM7v8aPV696EzBcnIpOWo8W3La3ujN4TMDxzGY
         AxFiwDLj2LUGm4WRuul00jyIvMZICgDyeOvPXVke2oRalDyseHnwDmMr/Br2er8UcFXX
         3aKA9XMDKsMZFGT4WDj9jqECiSd/87m33B7os=
MIME-Version: 1.0
Date: Tue, 6 Apr 2010 13:13:57 +0800
Message-ID: <u2mffe582101004052213zb2e4ec2dp110b8177c04f300e@mail.gmail.com>
Subject: in x86 architecture ,why the function atomic_sub_and_test() does not 
	disable the interrupt?
From: =?UTF-8?B?5p2o56GV?= <shanqn@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

static inline int atomic_sub_and_test(int i, atomic_t *v)
{
	unsigned char c;

	asm volatile(LOCK_PREFIX "subl %2,%0; sete %1"
		     : "+m" (v->counter), "=qm" (c)
		     : "ir" (i) : "memory");
	return c;
}

TIA:)
