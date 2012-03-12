Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350Ab2CLQQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 12:16:55 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:3389 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714Ab2CLQQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 12:16:53 -0400
Message-ID: <1331569011.4386.15.camel@lorien2>
Subject: simple_strtoull() - FIXME?
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: LKML <linux-kernel@vger.kernel.org>
Cc: shuahkhan@gmail.com
Date: Mon, 12 Mar 2012 10:16:51 -0600
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What's this FIXME in simple_strtoull() for? Something to be terribly
concerned about and need fixing (assuming there is something that still
needs fixing)

unsigned long long simple_strtoull(const char *cp, char **endp, unsigned
int base)
{
        unsigned long long result;
        unsigned int rv;

        cp = _parse_integer_fixup_radix(cp, &base);
        rv = _parse_integer(cp, base, &result);
        /* FIXME */
        cp += (rv & ~KSTRTOX_OVERFLOW);

        if (endp)
                *endp = (char *)cp;

        return result;
}
EXPORT_SYMBOL(simple_strtoull);

-- Shuah


