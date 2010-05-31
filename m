Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab0EaVHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 17:07:40 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41285 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab0EaVHj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 17:07:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nl0QeC27TclXWW6DB2OBz8/s3nt1BQ1OwiRcw7NcNWLfLnUII3nAndw+BCX39ijMW3
         xyFRzx/9Q204D6XMlZI/lN7lSWGeNdfGwjcpoMkYBPRBh6Dhcajh4m8MJj0HW6805HrO
         uUWKM9Z0Zqk6qoQT4lIHmrhX97dzSKT6aiX3Y=
MIME-Version: 1.0
In-Reply-To: <1275332796.6696.24.camel@tropicana>
References: <1275147754-3037-1-git-send-email-tardyp@gmail.com>
	<AANLkTikn53S1Gd_lf4jeu5dEy9C_RTGxxioN4EEYxM2C@mail.gmail.com>
	<1275332796.6696.24.camel@tropicana>
Date: Mon, 31 May 2010 23:07:38 +0200
Message-ID: <AANLkTimP7PwL7sRV_FVaa57JhWZ9wHJBYRnnbXPdj-ls@mail.gmail.com>
Subject: Re: [PATCH] trace-event-python: give field dict to unhandled callback
From: Pierre Tardy <tardyp@gmail.com>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The if statement expands to:
>
> if (!handler)
>  if ( --(dict)->ob_refcnt != 0) ; else
> ( (*((PyObject*)(dict))->ob_type->tp_dealloc)((PyObject *)((PyObject
> *)(dict))));
>
yeah, in python2.6 at least,  Py_DECREF is protected by do{ } while(0)
#define Py_DECREF(op)                                   \
        do {                                            \
            if (_Py_DEC_REFTOTAL  _Py_REF_DEBUG_COMMA   \
                --((PyObject*)(op))->ob_refcnt != 0)    \
                    _Py_CHECK_REFCNT(op)                \
            else                                        \
                _Py_Dealloc((PyObject *)(op));          \
        } while (0)

>       if (!handler) {
>               Py_DECREF(dict);
>       }

See a simpler fix in my next email.

-- 
Pierre
