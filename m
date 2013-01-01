Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355Ab3AAAPF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 19:15:05 -0500
Received: from [207.46.163.26] ([207.46.163.26]:59279 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750960Ab3AAAPB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 19:15:01 -0500
X-Forefront-Antispam-Report: CIP:157.56.232.213;KIP:(null);UIP:(null);IPV:NLI;H:BLUPRD0511HT005.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: PS1(zzzz1de0h1202h1e76h1d1ah1d2ahzz8275bh1954cbh17326ahz32i2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h1155h)
From: Scan Subscription <scan-subscription@coverity.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: New Defect(s) reported by Coverity Scan 
Thread-Topic: New Defect(s) reported by Coverity Scan 
Thread-Index: Ac3ntNcJ4nAo3ddpS2mWT36GUqviNA==
Date: Tue, 1 Jan 2013 00:13:35 +0000
Message-ID: <C0A4ACBB26D853488EA0C68388B70268168CDC32@BLUPRD0511MB401.namprd05.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [24.23.129.86]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: coverity.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Please find the latest report on new defect(s) that have been introduced to the Linux Kernel found with Coverity SCAN. 


Defect(s) Reported-by: Coverity Scan:
___________________________________________________________________________
** CID 753114: Use after free (USE_AFTER_FREE)
/drivers/block/rbd.c: 3662
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=753114


** CID 753112: Uninitialized scalar variable (UNINIT)
/fs/f2fs/node.c: 713
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=753112


** CID 753111: Uninitialized scalar variable (UNINIT)
/drivers/block/rbd.c: 2641
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=753111


** CID 753110: Use of untrusted scalar value (TAINTED_SCALAR)
/fs/nfsd/fault_inject.c: 138
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=753110


** CID 753109: Dereference null return value (NULL_RETURNS)
/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c: 1109
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=753109


** CID 753108: Dereference null return value (NULL_RETURNS)
/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c: 1207
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=753108


** CID 753107: Dereference null return value (NULL_RETURNS)
/drivers/infiniband/hw/cxgb4/cm.c: 2910
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=753107


** CID 753106: Dereference null return value (NULL_RETURNS)
/drivers/infiniband/hw/cxgb4/cm.c: 1463
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=753106


** CID 753105: Data race condition (MISSING_LOCK)
/fs/f2fs/node.h: 68
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=753105


** CID 753104: Data race condition (MISSING_LOCK)
/fs/f2fs/node.h: 67
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=753104


** CID 753103: Explicit null dereferenced (FORWARD_NULL)
/fs/f2fs/acl.c: 200
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=753103


** CID 753102: Unchecked return value (CHECKED_RETURN)
/fs/f2fs/recovery.c: 70
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=753102


** CID 753101: Unchecked return value (CHECKED_RETURN)
/drivers/vfio/pci/vfio_pci.c: 59
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=753101


###########################################################################
Defect Details:
___________________________________________________________________________
CID 753114: Use after free (USE_AFTER_FREE)
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=753114

/drivers/block/rbd.c: 3627 ( freed_arg)
   3624    	if (rc < 0)
   3625    		goto err_out_module;
   3626    
>>> "rbd_get_client(struct ceph_options *)" frees "ceph_opts".
   3627    	rbdc = rbd_get_client(ceph_opts);
   3628    	if (IS_ERR(rbdc)) {
   3629    		rc = PTR_ERR(rbdc);
   3630    		goto err_out_args;
   3631    	}
  

/drivers/block/rbd.c: 3662 ( deref_arg)
   3659    	rbd_put_client(rbdc);
   3660    err_out_args:
   3661    	if (ceph_opts)
>>> CID 753114: Use after free (USE_AFTER_FREE) Calling 
>>> "ceph_destroy_options(struct ceph_options *)" dereferences freed pointer "ceph_opts".
   3662    		ceph_destroy_options(ceph_opts);
   3663    	kfree(rbd_opts);
   3664    	rbd_spec_put(spec);
   3665    err_out_module:
   3666    	module_put(THIS_MODULE);
  
________________________________________________________________________
CID 753112: Uninitialized scalar variable (UNINIT)
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=753112

/fs/f2fs/node.c: 663 ( var_decl)
   660    	int level, offset[4], noffset[4];
   661    	unsigned int nofs;
   662    	struct f2fs_node *rn;
>>> Declaring variable "dn" without initializer.
   663    	struct dnode_of_data dn;
   664    	struct page *page;
   665    
   666    	level = get_node_path(from, offset, noffset);
   667    
  

/fs/f2fs/node.c: 713 ( uninit_use_in_call)
   710    
   711    		case NODE_IND1_BLOCK:
   712    		case NODE_IND2_BLOCK:
>>> CID 753112: Uninitialized scalar variable (UNINIT) Using 
>>> uninitialized value "dn": field "dn"."data_blkaddr" is uninitialized when calling "truncate_nodes(struct dnode_of_data *, unsigned int, int, int)".
   713    			err = truncate_nodes(&dn, nofs, offset[1], 2);
   714    			break;
   715    
   716    		case NODE_DIND_BLOCK:
   717    			err = truncate_nodes(&dn, nofs, offset[1], 3);
  
________________________________________________________________________
CID 753111: Uninitialized scalar variable (UNINIT)
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=753111

/drivers/block/rbd.c: 2596 ( var_decl)
   2593    	struct ceph_osd_client *osdc;
   2594    	const char *name;
   2595    	void *reply_buf = NULL;
>>> Declaring variable "ret" without initializer.
   2596    	int ret;
   2597    
   2598    	if (rbd_dev->spec->pool_name)
   2599    		return 0;	/* Already have the names */
   2600    
  

/drivers/block/rbd.c: 2641 ( uninit_use)
   2638    	kfree(rbd_dev->spec->pool_name);
   2639    	rbd_dev->spec->pool_name = NULL;
   2640    
>>> CID 753111: Uninitialized scalar variable (UNINIT) Using 
>>> uninitialized value "ret".
   2641    	return ret;
   2642    }
   2643    
   2644    static int rbd_dev_v2_snap_context(struct rbd_device *rbd_dev, u64 *ver)
   2645    {
  
________________________________________________________________________
CID 753110: Use of untrusted scalar value (TAINTED_SCALAR)
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=753110

/fs/nfsd/fault_inject.c: 130 ( tainted_data_argument)
   127    	struct sockaddr_storage sa;
   128    	u64 val;
   129    
>>> Calling function "copy_from_user(void *, void const *, unsigned long)" taints argument "write_buf".
   130    	if (copy_from_user(write_buf, buf, size))
   131    		return -EFAULT;
   132    	write_buf[size] = '\0';
   133    
   134    	size = rpc_pton(net, write_buf, size, (struct sockaddr *)&sa, sizeof(sa));
  

/fs/nfsd/fault_inject.c: 138 ( tainted_data)
   135    	if (size > 0)
   136    		nfsd_inject_set_client(file->f_dentry->d_inode->i_private, &sa, size);
   137    	else {
>>> CID 753110: Use of untrusted scalar value (TAINTED_SCALAR) Passing 
>>> tainted variable "write_buf" to a tainted sink.
   138    		val = simple_strtoll(write_buf, NULL, 0);
   139    		nfsd_inject_set(file->f_dentry->d_inode->i_private, val);
   140    	}
   141    	return len; /* on success, claim we got the whole input */
   142    }
  
________________________________________________________________________
CID 753109: Dereference null return value (NULL_RETURNS)
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=753109

/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c: 1108 ( returned_null)
   1105    
   1106    	ftid = adapter->tids.ftid_base + fidx;
   1107    
>>> Function "alloc_skb(unsigned int, gfp_t)" returns null (checked 379 out of 403 times).
   1108    	skb = alloc_skb(sizeof(*fwr), GFP_KERNEL | __GFP_NOFAIL);
   1109    	fwr = (struct fw_filter_wr *)__skb_put(skb, sizeof(*fwr));
   1110    	memset(fwr, 0, sizeof(*fwr));
   1111    
   1112    	/* It would be nice to put most of the following in t4_hw.c but most
  

/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c: 1108 ( var_assigned)
   1105    
   1106    	ftid = adapter->tids.ftid_base + fidx;
   1107    
>>> Assigning: "skb" = null return value from "alloc_skb(unsigned int, gfp_t)".
   1108    	skb = alloc_skb(sizeof(*fwr), GFP_KERNEL | __GFP_NOFAIL);
   1109    	fwr = (struct fw_filter_wr *)__skb_put(skb, sizeof(*fwr));
   1110    	memset(fwr, 0, sizeof(*fwr));
   1111    
   1112    	/* It would be nice to put most of the following in t4_hw.c but most
  

/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c: 1109 ( dereference)
   1106    	ftid = adapter->tids.ftid_base + fidx;
   1107    
   1108    	skb = alloc_skb(sizeof(*fwr), GFP_KERNEL | __GFP_NOFAIL);
>>> CID 753109: Dereference null return value (NULL_RETURNS) 
>>> Dereferencing a pointer that might be null "skb" when calling "__skb_put(struct sk_buff *, unsigned int)".
   1109    	fwr = (struct fw_filter_wr *)__skb_put(skb, sizeof(*fwr));
   1110    	memset(fwr, 0, sizeof(*fwr));
   1111    
   1112    	/* It would be nice to put most of the following in t4_hw.c but most
   1113    	 * of the work is translating the cxgbtool ch_filter_specification
  
________________________________________________________________________
CID 753108: Dereference null return value (NULL_RETURNS)
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=753108

/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c: 1206 ( returned_null)
   1203    	len = sizeof(*fwr);
   1204    	ftid = adapter->tids.ftid_base + fidx;
   1205    
>>> Function "alloc_skb(unsigned int, gfp_t)" returns null (checked 379 out of 403 times).
   1206    	skb = alloc_skb(len, GFP_KERNEL | __GFP_NOFAIL);
   1207    	fwr = (struct fw_filter_wr *)__skb_put(skb, len);
   1208    	t4_mk_filtdelwr(ftid, fwr, adapter->sge.fw_evtq.abs_id);
   1209    
   1210    	/* Mark the filter as "pending" and ship off the Filter Work Request.
  

/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c: 1206 ( var_assigned)
   1203    	len = sizeof(*fwr);
   1204    	ftid = adapter->tids.ftid_base + fidx;
   1205    
>>> Assigning: "skb" = null return value from "alloc_skb(unsigned int, gfp_t)".
   1206    	skb = alloc_skb(len, GFP_KERNEL | __GFP_NOFAIL);
   1207    	fwr = (struct fw_filter_wr *)__skb_put(skb, len);
   1208    	t4_mk_filtdelwr(ftid, fwr, adapter->sge.fw_evtq.abs_id);
   1209    
   1210    	/* Mark the filter as "pending" and ship off the Filter Work Request.
  

/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c: 1207 ( dereference)
   1204    	ftid = adapter->tids.ftid_base + fidx;
   1205    
   1206    	skb = alloc_skb(len, GFP_KERNEL | __GFP_NOFAIL);
>>> CID 753108: Dereference null return value (NULL_RETURNS) 
>>> Dereferencing a pointer that might be null "skb" when calling "__skb_put(struct sk_buff *, unsigned int)".
   1207    	fwr = (struct fw_filter_wr *)__skb_put(skb, len);
   1208    	t4_mk_filtdelwr(ftid, fwr, adapter->sge.fw_evtq.abs_id);
   1209    
   1210    	/* Mark the filter as "pending" and ship off the Filter Work Request.
   1211    	 * When we get the Work Request Reply we'll clear the pending status.
  
________________________________________________________________________
CID 753107: Dereference null return value (NULL_RETURNS)
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=753107

/drivers/infiniband/hw/cxgb4/cm.c: 2909 ( returned_null)
   2906    	struct fw_ofld_connection_wr *req;
   2907    	struct cpl_pass_accept_req *cpl = cplhdr(skb);
   2908    
>>> Function "alloc_skb(unsigned int, gfp_t)" returns null (checked 379 out of 403 times).
   2909    	req_skb = alloc_skb(sizeof(struct fw_ofld_connection_wr), GFP_KERNEL);
   2910    	req = (struct fw_ofld_connection_wr *)__skb_put(req_skb, sizeof(*req));
   2911    	memset(req, 0, sizeof(*req));
   2912    	req->op_compl = htonl(V_WR_OP(FW_OFLD_CONNECTION_WR) | FW_WR_COMPL(1));
   2913    	req->len16_pkd = htonl(FW_WR_LEN16(DIV_ROUND_UP(sizeof(*req), 16)));
  

/drivers/infiniband/hw/cxgb4/cm.c: 2909 ( var_assigned)
   2906    	struct fw_ofld_connection_wr *req;
   2907    	struct cpl_pass_accept_req *cpl = cplhdr(skb);
   2908    
>>> Assigning: "req_skb" = null return value from "alloc_skb(unsigned int, gfp_t)".
   2909    	req_skb = alloc_skb(sizeof(struct fw_ofld_connection_wr), GFP_KERNEL);
   2910    	req = (struct fw_ofld_connection_wr *)__skb_put(req_skb, sizeof(*req));
   2911    	memset(req, 0, sizeof(*req));
   2912    	req->op_compl = htonl(V_WR_OP(FW_OFLD_CONNECTION_WR) | FW_WR_COMPL(1));
   2913    	req->len16_pkd = htonl(FW_WR_LEN16(DIV_ROUND_UP(sizeof(*req), 16)));
  

/drivers/infiniband/hw/cxgb4/cm.c: 2910 ( dereference)
   2907    	struct cpl_pass_accept_req *cpl = cplhdr(skb);
   2908    
   2909    	req_skb = alloc_skb(sizeof(struct fw_ofld_connection_wr), GFP_KERNEL);
>>> CID 753107: Dereference null return value (NULL_RETURNS) 
>>> Dereferencing a pointer that might be null "req_skb" when calling "__skb_put(struct sk_buff *, unsigned int)".
   2910    	req = (struct fw_ofld_connection_wr *)__skb_put(req_skb, sizeof(*req));
   2911    	memset(req, 0, sizeof(*req));
   2912    	req->op_compl = htonl(V_WR_OP(FW_OFLD_CONNECTION_WR) | FW_WR_COMPL(1));
   2913    	req->len16_pkd = htonl(FW_WR_LEN16(DIV_ROUND_UP(sizeof(*req), 16)));
   2914    	req->le.version_cpl = htonl(F_FW_OFLD_CONNECTION_WR_CPL);
  
________________________________________________________________________
CID 753106: Dereference null return value (NULL_RETURNS)
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=753106

/drivers/infiniband/hw/cxgb4/cm.c: 1462 ( returned_null)
   1459    	unsigned int mtu_idx;
   1460    	int wscale;
   1461    
>>> Function "get_skb(struct sk_buff *, int, gfp_t)" returns null (checked 10 out of 12 times).
   1462    	skb = get_skb(NULL, sizeof(*req), GFP_KERNEL);
   1463    	req = (struct fw_ofld_connection_wr *)__skb_put(skb, sizeof(*req));
   1464    	memset(req, 0, sizeof(*req));
   1465    	req->op_compl = htonl(V_WR_OP(FW_OFLD_CONNECTION_WR));
   1466    	req->len16_pkd = htonl(FW_WR_LEN16(DIV_ROUND_UP(sizeof(*req), 16)));
  

/drivers/infiniband/hw/cxgb4/cm.c: 1462 ( var_assigned)
   1459    	unsigned int mtu_idx;
   1460    	int wscale;
   1461    
>>> Assigning: "skb" = null return value from "get_skb(struct sk_buff *, int, gfp_t)".
   1462    	skb = get_skb(NULL, sizeof(*req), GFP_KERNEL);
   1463    	req = (struct fw_ofld_connection_wr *)__skb_put(skb, sizeof(*req));
   1464    	memset(req, 0, sizeof(*req));
   1465    	req->op_compl = htonl(V_WR_OP(FW_OFLD_CONNECTION_WR));
   1466    	req->len16_pkd = htonl(FW_WR_LEN16(DIV_ROUND_UP(sizeof(*req), 16)));
  

/drivers/infiniband/hw/cxgb4/cm.c: 1463 ( dereference)
   1460    	int wscale;
   1461    
   1462    	skb = get_skb(NULL, sizeof(*req), GFP_KERNEL);
>>> CID 753106: Dereference null return value (NULL_RETURNS) 
>>> Dereferencing a pointer that might be null "skb" when calling "__skb_put(struct sk_buff *, unsigned int)".
   1463    	req = (struct fw_ofld_connection_wr *)__skb_put(skb, sizeof(*req));
   1464    	memset(req, 0, sizeof(*req));
   1465    	req->op_compl = htonl(V_WR_OP(FW_OFLD_CONNECTION_WR));
   1466    	req->len16_pkd = htonl(FW_WR_LEN16(DIV_ROUND_UP(sizeof(*req), 16)));
   1467    	req->le.filter = cpu_to_be32(select_ntuple(ep->com.dev, ep->dst,
  
________________________________________________________________________
CID 753105: Data race condition (MISSING_LOCK)
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=753105

/fs/f2fs/node.h: 68 ( missing_lock)
   65    {
   66    	ni->ino = le32_to_cpu(raw_ne->ino);
   67    	ni->blk_addr = le32_to_cpu(raw_ne->block_addr);
>>> CID 753105: Data race condition (MISSING_LOCK) Accessing 
>>> "ni->version" without holding lock "f2fs_nm_info.nat_tree_lock". Elsewhere, "ni->version" is accessed with "f2fs_nm_info.nat_tree_lock" held 4 out of 5 times.
   68    	ni->version = raw_ne->version;
   69    }
   70    
   71    /*
   72     * For free nid mangement
  
________________________________________________________________________
CID 753104: Data race condition (MISSING_LOCK)
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=753104

/fs/f2fs/node.h: 67 ( missing_lock)
   64    						struct f2fs_nat_entry *raw_ne)
   65    {
   66    	ni->ino = le32_to_cpu(raw_ne->ino);
>>> CID 753104: Data race condition (MISSING_LOCK) Accessing 
>>> "ni->blk_addr" without holding lock "f2fs_nm_info.nat_tree_lock". Elsewhere, "ni->blk_addr" is accessed with "f2fs_nm_info.nat_tree_lock" held 4 out of 5 times.
   67    	ni->blk_addr = le32_to_cpu(raw_ne->block_addr);
   68    	ni->version = raw_ne->version;
   69    }
   70    
   71    /*
  
________________________________________________________________________
CID 753103: Explicit null dereferenced (FORWARD_NULL)
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=753103

/fs/f2fs/acl.c: 172 ( assign_zero)
   169    {
   170    	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
   171    	int name_index = F2FS_XATTR_INDEX_POSIX_ACL_DEFAULT;
>>> Assigning: "value" = "NULL".
   172    	void *value = NULL;
   173    	struct posix_acl *acl;
   174    	int retval;
   175    
   176    	if (!test_opt(sbi, POSIX_ACL))
  

/fs/f2fs/acl.c: 200 ( var_deref_model)
   197    		else
   198    			acl = ERR_PTR(retval);
   199    	} else {
>>> CID 753103: Explicit null dereferenced (FORWARD_NULL) Passing null 
>>> pointer "value" to function "f2fs_acl_from_disk(char const *, size_t)", which dereferences it.
   200    		acl = f2fs_acl_from_disk(value, retval);
   201    	}
   202    	kfree(value);
   203    	if (!IS_ERR(acl))
   204    		set_cached_acl(inode, type, acl);
  
________________________________________________________________________
CID 753102: Unchecked return value (CHECKED_RETURN)
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=753102

/fs/f2fs/recovery.c: 70 ( check_return)
   67    		kunmap(page);
   68    		f2fs_put_page(page, 0);
   69    	} else {
>>> CID 753102: Unchecked return value (CHECKED_RETURN) Calling function 
>>> "f2fs_add_link(struct dentry *, struct inode *)" without checking return value (as is done elsewhere 6 out of 7 times).
   70    		f2fs_add_link(&dent, inode);
   71    	}
   72    	iput(dir);
   73    out:
   74    	kunmap(ipage);
  

/fs/f2fs/recovery.c: 70 ( unchecked_value)
   67    		kunmap(page);
   68    		f2fs_put_page(page, 0);
   69    	} else {
>>> No check of the return value of "f2fs_add_link(&dent, inode)".
   70    		f2fs_add_link(&dent, inode);
   71    	}
   72    	iput(dir);
   73    out:
   74    	kunmap(ipage);
  
________________________________________________________________________
CID 753101: Unchecked return value (CHECKED_RETURN)
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=753101

/drivers/vfio/pci/vfio_pci.c: 59 ( check_return)
   56    
   57    	ret = vfio_config_init(vdev);
   58    	if (ret) {
>>> CID 753101: Unchecked return value (CHECKED_RETURN) Calling function 
>>> "pci_load_and_free_saved_state(struct pci_dev *, struct pci_saved_state **)" without checking return value (as is done elsewhere 4 out of 5 times).
   59    		pci_load_and_free_saved_state(pdev, &vdev->pci_saved_state);
   60    		pci_disable_device(pdev);
   61    		return ret;
   62    	}
   63    
  

/drivers/vfio/pci/vfio_pci.c: 59 ( unchecked_value)
   56    
   57    	ret = vfio_config_init(vdev);
   58    	if (ret) {
>>> No check of the return value of "pci_load_and_free_saved_state(pdev, &vdev->pci_saved_state)".
   59    		pci_load_and_free_saved_state(pdev, &vdev->pci_saved_state);
   60    		pci_disable_device(pdev);
   61    		return ret;
   62    	}
   63    
  
________________________________________________________________________


To view the defects in Coverity Scan visit, http://scan5.coverity.com:8080.  
Your username should be the first part of your email address. If you don't have a username, you can request one by emailing: scan-admin at coverity.com
	
Thank you,
Dakshesh Vyas
Coverity SCAN-ADMIN
scan-admin at coverity.com
http://scan.coverity.com


